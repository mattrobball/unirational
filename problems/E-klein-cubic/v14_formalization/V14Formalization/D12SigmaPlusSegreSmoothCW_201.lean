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

def CW_201_0_pre : Polynomial ℚ := interpQ 8639957931 [7455482203776, 55606806285024, 104173455288142, 164234503691093, 234539684546624, 267835288530567, 294266289611708, 305227421270490, 282822137668171, 278556860451588, 275243336673407, 266629632464896, 219636530388383, 174383405163446, 118587633977078, 52272414725566, 21314195514745, -5116805566396, -18415321998300]
def CW_201_0_pim : Polynomial ℚ := interpQ 8639957931 [-25150031935204, -50300063870408, -47523496582202, -48574591404354, -13304499568624, 39282110380588, 79976853117936, 132384443794696, 160387771752822, 159795210159442, 156940995577722, 177930999302340, 198921003026958, 193290221157032, 193748754385804, 160219754056700, 111339618632918, 74963352602830, 26262236451500]
theorem CW_201_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_101 - CW_0_im_100 * Fplus_dU_im_101 = CW_201_0_pre := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_201_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_201_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_101 + CW_0_im_100 * Fplus_dU_re_101 = CW_201_0_pim := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_201_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_201_0_mul :
    CW_0_c_100 * Fplus_dU_c_101 = ofLadj CW_201_0_pre CW_201_0_pim := by
  rw [CW_0_c_100_def, Fplus_dU_c_101_def, ofLadj_mul, CW_201_0_pre_eq, CW_201_0_pim_eq]

def CW_201_1_pre : Polynomial ℚ := interpQ 8639957931 [-2651009789324, -43108480874960, -87096741934501, -143246637580294, -213616646715063, -253127314950928, -286102164042290, -303630231140267, -289388187308521, -283892437643425, -279721319070088, -275481160492478, -236612838195128, -196795695708924, -146141549728227, -80772295475125, -44244535928331, -11269686836969, 9241288950079]
def CW_201_1_pim : Polynomial ℚ := interpQ 8639957931 [29250967870566, 58501935741132, 68692399958243, 81782675213790, 61168686995669, 22068197339136, -9292292862840, -55986549660084, -82506762307492, -81711744185321, -78093870606814, -102032782619538, -125971694632262, -132544285270866, -144839542404242, -126567100564832, -92089815453529, -66249718520711, -24178666268697]
theorem CW_201_1_pre_eq :
    CW_1_re_100 * Fplus_dV_re_101 - CW_1_im_100 * Fplus_dV_im_101 = CW_201_1_pre := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_201_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_201_1_pim_eq :
    CW_1_re_100 * Fplus_dV_im_101 + CW_1_im_100 * Fplus_dV_re_101 = CW_201_1_pim := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_201_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_201_1_mul :
    CW_1_c_100 * Fplus_dV_c_101 = ofLadj CW_201_1_pre CW_201_1_pim := by
  rw [CW_1_c_100_def, Fplus_dV_c_101_def, ofLadj_mul, CW_201_1_pre_eq, CW_201_1_pim_eq]

def CW_201_2_pre : Polynomial ℚ := interpQ 8639957931 [296503158781, -13943080318244, -26533510810814, -43865494944953, -67500332399994, -79866032280552, -94342813199784, -102092426527581, -100211479848733, -101658736696242, -102638861803874, -103456356762214, -88695781485630, -75125225885428, -56345984903780, -31540122224007, -18412651720792, -3935870801560, 3051971903580]
def CW_201_2_pim : Polynomial ℚ := interpQ 8639957931 [10434292813147, 20868585626294, 24158184113090, 32092940143378, 26503604931813, 17320737426936, 9928741895048, -5256952510240, -12784719980249, -13032875460080, -13909258536099, -25691560852160, -37473863168221, -41639844731036, -49822756241155, -43528382203927, -33293829964460, -24470185435550, -8232806295672]
theorem CW_201_2_pre_eq :
    CW_2_re_100 * Fplus_dW_re_101 - CW_2_im_100 * Fplus_dW_im_101 = CW_201_2_pre := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_201_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_201_2_pim_eq :
    CW_2_re_100 * Fplus_dW_im_101 + CW_2_im_100 * Fplus_dW_re_101 = CW_201_2_pim := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_201_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_201_2_mul :
    CW_2_c_100 * Fplus_dW_c_101 = ofLadj CW_201_2_pre CW_201_2_pim := by
  rw [CW_2_c_100_def, Fplus_dW_c_101_def, ofLadj_mul, CW_201_2_pre_eq, CW_201_2_pim_eq]

theorem CW_201_3_mul : CW_3_c_200 = ofLadj CW_3_re_200 CW_3_im_200 := CW_3_c_200_def

@[expose] public def CW_coeff_201 : Ki := CW_0_c_100 * Fplus_dU_c_101 + CW_1_c_100 * Fplus_dV_c_101 + CW_2_c_100 * Fplus_dW_c_101 + CW_3_c_200

theorem CW_coeff_201_sum :
    CW_coeff_201 = ofLadj (CW_201_0_pre + CW_201_1_pre + CW_201_2_pre + CW_3_re_200) (CW_201_0_pim + CW_201_1_pim + CW_201_2_pim + CW_3_im_200) := by
  simp only [CW_coeff_201, CW_201_0_mul, CW_201_1_mul, CW_201_2_mul, CW_201_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_201_0_pre CW_201_0_pim CW_201_1_pre CW_201_1_pim CW_201_2_pre CW_201_2_pim CW_3_re_200 CW_3_im_200

def CW_201_qre : Polynomial ℚ := interpQ 8639957931 [5191040589241, -6635795497421, -8134572861469, -13637615775977, -23859897681363, -18697010839188, -21020628929453, -14200302060284, -6122061144641]
def CW_201_qim : Polynomial ℚ := interpQ 8639957931 [14731210604167, 14731210604167, 16369354071345, 20019635414723, 8962184452466, 4168298073012, 1712524568360, -9607315240562, -6149236112869]
theorem CW_coeff_201_poly_re :
    CW_201_0_pre + CW_201_1_pre + CW_201_2_pre + CW_3_re_200 = (0 : Polynomial ℚ) + Phi11 * CW_201_qre := by
  rw [phi11_interpQ]
  simp only [CW_201_0_pre, CW_201_1_pre, CW_201_2_pre, CW_3_re_200_def, CW_201_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_201_poly_im :
    CW_201_0_pim + CW_201_1_pim + CW_201_2_pim + CW_3_im_200 = (0 : Polynomial ℚ) + Phi11 * CW_201_qim := by
  rw [phi11_interpQ]
  simp only [CW_201_0_pim, CW_201_1_pim, CW_201_2_pim, CW_3_im_200_def, CW_201_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_201_eq :
    CW_coeff_201 = (0 : Ki) := by
  rw [CW_coeff_201_sum, CW_coeff_201_poly_re,
    CW_coeff_201_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
