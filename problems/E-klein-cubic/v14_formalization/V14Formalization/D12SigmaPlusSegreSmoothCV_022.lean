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

def CV_022_0_pre : Polynomial ℚ := interpQ 8639957931 [-565034345376, -716372136803400, -1356529855828056, -2335563825222406, -3811436651274424, -4918280617672744, -5995481187657862, -6864359647903938, -6979310888493478, -7222920023407856, -7408828933940838, -7477684963101384, -6692456797137438, -5866390167579800, -4643747063271072, -2944115310965714, -1704227827677564, -627027257692446, 108807685663800]
def CV_022_0_pim : Polynomial ℚ := interpQ 8639957931 [661424551534500, 1322849103069000, 1787346060570768, 2510103130234344, 2626706809105216, 2335597368131006, 2048222360377760, 1220195278075416, 626544073672612, 591547892768938, 430425775381854, -467108986552060, -1364643748485974, -1990262823374826, -2748016073942076, -2762404475721144, -2264306004688312, -1730882593855574, -695866481494608]
theorem CV_022_0_pre_eq :
    CV_0_re_002 * Fplus_dU_re_020 - CV_0_im_002 * Fplus_dU_im_020 = CV_022_0_pre := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_022_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_022_0_pim_eq :
    CV_0_re_002 * Fplus_dU_im_020 + CV_0_im_002 * Fplus_dU_re_020 = CV_022_0_pim := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_022_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_022_0_mul :
    CV_0_c_002 * Fplus_dU_c_020 = ofLadj CV_022_0_pre CV_022_0_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_020_def, ofLadj_mul, CV_022_0_pre_eq, CV_022_0_pim_eq]

def CV_022_1_pre : Polynomial ℚ := interpQ 8639957931 [67819451902758, 651724878279000, 1135211180011140, 1832718082718220, 2768696377881168, 3148148114572938, 3611005895395494, 4143812245078362, 4243600672643766, 4574729750895438, 4827792746908602, 4854104259404376, 4176067868629602, 3439518570884298, 2410882589925546, 1170420581291850, 610094134759146, 147236353936590, -204695285905344]
def CV_022_1_pim : Polynomial ℚ := interpQ 8639957931 [-373418322972996, -746836645945992, -860723851662516, -1115938718280834, -839186541143862, -378192551330562, -253889312535786, 214703913885480, 572182992593514, 619904360449146, 838985745538566, 1533527217402816, 2228068689267066, 2561037280073010, 2863973514546960, 2448069791253234, 1705700727537786, 1246598925188202, 496630624864788]
theorem CV_022_1_pre_eq :
    CV_1_re_002 * Fplus_dV_re_020 - CV_1_im_002 * Fplus_dV_im_020 = CV_022_1_pre := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_022_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_022_1_pim_eq :
    CV_1_re_002 * Fplus_dV_im_020 + CV_1_im_002 * Fplus_dV_re_020 = CV_022_1_pim := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_022_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_022_1_mul :
    CV_1_c_002 * Fplus_dV_c_020 = ofLadj CV_022_1_pre CV_022_1_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_020_def, ofLadj_mul, CV_022_1_pre_eq, CV_022_1_pim_eq]

def CV_022_2_pre : Polynomial ℚ := interpQ 8639957931 [78940911432320, 1139632422495392, 2258571452231908, 3704299708514084, 5525377174590058, 6580879620829434, 7443933321055468, 7963102554231664, 7586134966342706, 7500428863551820, 7434774504063094, 7331565571947968, 6295142081567702, 5241857411319912, 3881835257828622, 2139702281360372, 1131019510001416, 267965809775382, -298023098281234]
def CV_022_2_pim : Polynomial ℚ := interpQ 8639957931 [-776729706224176, -1553459412448352, -1821474716465468, -2188273259903436, -1679780211721662, -648953822106378, 186859189731508, 1444392395882478, 2176594780486950, 2164169737582304, 2107439636057360, 2800974604422944, 3494509572788528, 3705794775280700, 4060168275814022, 3587807108593942, 2629792728577928, 1880791700194478, 696070503642778]
theorem CV_022_2_pre_eq :
    CV_2_re_002 * Fplus_dW_re_020 - CV_2_im_002 * Fplus_dW_im_020 = CV_022_2_pre := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_022_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_022_2_pim_eq :
    CV_2_re_002 * Fplus_dW_im_020 + CV_2_im_002 * Fplus_dW_re_020 = CV_022_2_pim := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_022_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_022_2_mul :
    CV_2_c_002 * Fplus_dW_c_020 = ofLadj CV_022_2_pre CV_022_2_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_020_def, ofLadj_mul, CV_022_2_pre_eq, CV_022_2_pim_eq]

theorem CV_022_3_mul : CV_3_c_012 = ofLadj CV_3_re_012 CV_3_im_012 := CV_3_c_012_def

@[expose] public def CV_coeff_022 : Ki := CV_0_c_002 * Fplus_dU_c_020 + CV_1_c_002 * Fplus_dV_c_020 + CV_2_c_002 * Fplus_dW_c_020 + CV_3_c_012

theorem CV_coeff_022_sum :
    CV_coeff_022 = ofLadj (CV_022_0_pre + CV_022_1_pre + CV_022_2_pre + CV_3_re_012) (CV_022_0_pim + CV_022_1_pim + CV_022_2_pim + CV_3_im_012) := by
  simp only [CV_coeff_022, CV_022_0_mul, CV_022_1_mul, CV_022_2_mul, CV_022_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_022_0_pre CV_022_0_pim CV_022_1_pre CV_022_1_pim CV_022_2_pre CV_022_2_pim CV_3_re_012 CV_3_im_012

def CV_022_qre : Polynomial ℚ := interpQ 8639957931 [145753448779898, 929231715191094, 963767338435456, 1166015030141314, 1282963232796588, 329121734603510, 248710911063472, 182085604542304, -393910698522778]
def CV_022_qim : Polynomial ℚ := interpQ 8639957931 [-490541678295920, -490541678295920, 81365281590736, 100443515559978, 902653292292874, 1202284972698630, 674679419900296, 899673384514148, 496834647012958]
theorem CV_coeff_022_poly_re :
    CV_022_0_pre + CV_022_1_pre + CV_022_2_pre + CV_3_re_012 = (0 : Polynomial ℚ) + Phi11 * CV_022_qre := by
  rw [phi11_interpQ]
  simp only [CV_022_0_pre, CV_022_1_pre, CV_022_2_pre, CV_3_re_012_def, CV_022_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_022_poly_im :
    CV_022_0_pim + CV_022_1_pim + CV_022_2_pim + CV_3_im_012 = (0 : Polynomial ℚ) + Phi11 * CV_022_qim := by
  rw [phi11_interpQ]
  simp only [CV_022_0_pim, CV_022_1_pim, CV_022_2_pim, CV_3_im_012_def, CV_022_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_022_eq :
    CV_coeff_022 = (0 : Ki) := by
  rw [CV_coeff_022_sum, CV_coeff_022_poly_re,
    CV_coeff_022_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
