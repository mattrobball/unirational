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

def CV_110_0_pre : Polynomial ℚ := interpQ 17279915862 [1702371588773, -130741074823736, -260227060374950, -424465412443747, -718946622220534, -919723392768731, -1109896135682213, -1191975660551952, -1109244976842598, -1050425245747339, -1005072435856534, -990223581743344, -874331361032798, -790198185372389, -684779564398851, -444725122640549, -276162733322611, -85989990409129, 28303915690869]
def CV_110_0_pim : Polynomial ℚ := interpQ 17279915862 [124223480554971, 248446961109942, 320165411090410, 440385837378727, 442713350639260, 325271373674237, 196050571426309, -53939840166418, -187999196347466, -179951106540623, -140619614749670, -207680515735090, -274741416720510, -307128374910025, -419300711391499, -445813461980183, -379213420668295, -309022594792489, -109874118852897]
theorem CV_110_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_110 - CV_0_im_000 * Fplus_dU_im_110 = CV_110_0_pre := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_110_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_110_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_110 + CV_0_im_000 * Fplus_dU_re_110 = CV_110_0_pim := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_110_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_110_0_mul :
    CV_0_c_000 * Fplus_dU_c_110 = ofLadj CV_110_0_pre CV_110_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_110_def, ofLadj_mul, CV_110_0_pre_eq, CV_110_0_pim_eq]

def CV_110_1_pre : Polynomial ℚ := interpQ 17279915862 [391826074356, -270076688425600, -510223881445427, -879581860641214, -1435939105688795, -1852225815470207, -2259051488621808, -2585761649051785, -2629081591081641, -2720549857576287, -2791018612023209, -2817066636213988, -2520941923597609, -2210325976130860, -1749499730440427, -1108506075130774, -642183667647945, -235357994496344, 41316468232216]
def CV_110_1_pim : Polynomial ℚ := interpQ 17279915862 [249539008156100, 499078016312200, 673680021800319, 947355575241464, 990242963622841, 881407186449977, 773026323041508, 460803383615409, 237462364544967, 224502781188865, 163575680160525, -174858451341760, -513292582844045, -748821689360504, -1035456826157751, -1040185902516324, -852898837489693, -652173558373112, -261499331093246]
theorem CV_110_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_110 - CV_1_im_000 * Fplus_dV_im_110 = CV_110_1_pre := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_110_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_110_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_110 + CV_1_im_000 * Fplus_dV_re_110 = CV_110_1_pim := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_110_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_110_1_mul :
    CV_1_c_000 * Fplus_dV_c_110 = ofLadj CV_110_1_pre CV_110_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_110_def, ofLadj_mul, CV_110_1_pre_eq, CV_110_1_pim_eq]

def CV_110_2_pre : Polynomial ℚ := interpQ 17279915862 [-17922325550900, -256030560191600, -518935542485338, -852414789765666, -1270893427368788, -1508021887013013, -1702473970951475, -1806940856673375, -1722531108879426, -1690012301630217, -1665091102778374, -1638062957018000, -1409060542586774, -1171076759144879, -870116319113760, -481604805121121, -262138072816110, -67685988877648, 54442624183466]
def CV_110_2_pim : Polynomial ℚ := interpQ 17279915862 [172820550488710, 345641100977420, 407624923466254, 483360748854214, 362516401409876, 129216380173929, -59660331377923, -335958347075423, -494390809417824, -489506327887919, -468050267519674, -609319705136120, -750589142752566, -791116904873155, -861968248731210, -755101344783821, -549170826836666, -393383531254160, -144455018845452]
theorem CV_110_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_110 - CV_2_im_000 * Fplus_dW_im_110 = CV_110_2_pre := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_110_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_110_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_110 + CV_2_im_000 * Fplus_dW_re_110 = CV_110_2_pim := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_110_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_110_2_mul :
    CV_2_c_000 * Fplus_dW_c_110 = ofLadj CV_110_2_pre CV_110_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_110_def, ofLadj_mul, CV_110_2_pre_eq, CV_110_2_pim_eq]

def CV_110_3_pre : Polynomial ℚ := interpQ 17279915862 [-847795014, 0, -194745704274, -324473854452, -566992487556, -726581619500, -726581619500, -566992487556, -324473854452, -194745704274]
def CV_110_3_pim : Polynomial ℚ := interpQ 17279915862 [181430904370, 362861808740, 502410677882, 529422697236, 533791499532, 293942587692, 68919221048, -170929690792, -166560888496, -139548869142]
theorem CV_110_3_neg_re : -CV_3_re_110 = CV_110_3_pre := by
  simp only [CV_3_re_110_def, CV_110_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_110_3_neg_im : -CV_3_im_110 = CV_110_3_pim := by
  simp only [CV_3_im_110_def, CV_110_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_110_3_mul : -CV_3_c_110 = ofLadj CV_110_3_pre CV_110_3_pim := by
  rw [CV_3_c_110_def, ofLadj_neg, CV_110_3_neg_re, CV_110_3_neg_im]

@[expose] public def CV_coeff_110 : Ki := CV_0_c_000 * Fplus_dU_c_110 + CV_1_c_000 * Fplus_dV_c_110 + CV_2_c_000 * Fplus_dW_c_110 + (-CV_3_c_110)

theorem CV_coeff_110_sum :
    CV_coeff_110 = ofLadj (CV_110_0_pre + CV_110_1_pre + CV_110_2_pre + CV_110_3_pre) (CV_110_0_pim + CV_110_1_pim + CV_110_2_pim + CV_110_3_pim) := by
  simp only [CV_coeff_110, CV_110_0_mul, CV_110_1_mul, CV_110_2_mul, CV_110_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_110_0_pre CV_110_0_pim CV_110_1_pre CV_110_1_pim CV_110_2_pre CV_110_2_pim CV_110_3_pre CV_110_3_pim

def CV_110_qre : Polynomial ℚ := interpQ 17279915862 [-15828975682785, -641019347758151, -632732906569053, -867205306695090, -1269559611060594, -854351529105778, -791450500003545, -513096981889672, 124063008106551]
def CV_110_qim : Polynomial ℚ := interpQ 17279915862 [546764470104151, 546764470104151, 308443826826563, 469658817136776, -75625077000132, -459817624285674, -426703400574893, -838751215628166, -515828468791595]
theorem CV_coeff_110_poly_re :
    CV_110_0_pre + CV_110_1_pre + CV_110_2_pre + CV_110_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_110_qre := by
  rw [phi11_interpQ]
  simp only [CV_110_0_pre, CV_110_1_pre, CV_110_2_pre, CV_110_3_pre, CV_110_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_110_poly_im :
    CV_110_0_pim + CV_110_1_pim + CV_110_2_pim + CV_110_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_110_qim := by
  rw [phi11_interpQ]
  simp only [CV_110_0_pim, CV_110_1_pim, CV_110_2_pim, CV_110_3_pim, CV_110_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_110_eq :
    CV_coeff_110 = (0 : Ki) := by
  rw [CV_coeff_110_sum, CV_coeff_110_poly_re,
    CV_coeff_110_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
