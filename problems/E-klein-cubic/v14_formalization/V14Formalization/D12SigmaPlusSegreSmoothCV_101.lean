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

def CV_101_0_pre : Polynomial ℚ := interpQ 17279915862 [71790834318524, 522964299294944, 983881971222692, 1547058307166965, 2204761635926268, 2524940841213346, 2766051062070230, 2876081840155439, 2664466363586024, 2624348713387102, 2593133228585012, 2510287357620976, 2070168929290068, 1640466742164410, 1117408056419059, 497067773549599, 198798551612871, -42311669244013, -174252430679572]
def CV_101_0_pim : Polynomial ℚ := interpQ 17279915862 [-235411772572412, -470823545144824, -446165374872688, -448371793643311, -123586430062026, 376238869352974, 758721239287316, 1247844978850889, 1516923411985146, 1510975614470262, 1484296624556132, 1680539049294644, 1876781474033156, 1825444313846890, 1821702935102629, 1514065224873073, 1048408606417791, 706885838386383, 251930779782528]
theorem CV_101_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_101 - CV_0_im_000 * Fplus_dU_im_101 = CV_101_0_pre := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_101_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_101_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_101 + CV_0_im_000 * Fplus_dU_re_101 = CV_101_0_pim := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_101_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_101_0_mul :
    CV_0_c_000 * Fplus_dU_c_101 = ofLadj CV_101_0_pre CV_101_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_101_def, ofLadj_mul, CV_101_0_pre_eq, CV_101_0_pim_eq]

def CV_101_1_pre : Polynomial ℚ := interpQ 17279915862 [-39163993839968, -540153376851200, -1097501242538110, -1804726429671124, -2687561397456974, -3192660366077250, -3601532997629882, -3824481357397055, -3643473523979989, -3574530472999403, -3521983180335648, -3463142052599638, -2981829803484448, -2477029230461293, -1838747094308865, -1019204643263407, -551770647867754, -142898016315122, 117715316676674]
def CV_101_1_pim : Polynomial ℚ := interpQ 17279915862 [364039672099400, 728079344198800, 863160920618248, 1018281421513792, 765359222024970, 268197922176498, -130783783105840, -717663582240053, -1053238315588677, -1043309419246963, -997738171988724, -1294985312173120, -1592232452357516, -1681742781518725, -1826934386072555, -1602939178485957, -1164316828506038, -834988590712060, -306647741446400]
theorem CV_101_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_101 - CV_1_im_000 * Fplus_dV_im_101 = CV_101_1_pre := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_101_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_101_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_101 + CV_1_im_000 * Fplus_dV_re_101 = CV_101_1_pim := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_101_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_101_1_mul :
    CV_1_c_000 * Fplus_dV_c_101 = ofLadj CV_101_1_pre CV_101_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_101_def, ofLadj_mul, CV_101_1_pre_eq, CV_101_1_pim_eq]

def CV_101_2_pre : Polynomial ℚ := interpQ 17279915862 [-20482724321560, -358442784268240, -712661509622556, -1156561398578961, -1760465860197265, -2124753237648761, -2462650130194018, -2684026203309922, -2640188410095409, -2676154682080363, -2702568551089048, -2692979534606078, -2344125766820808, -1963493172457807, -1483627011516448, -847610934135751, -463741805689030, -125844913143773, 75949408976906]
def CV_101_2_pim : Polynomial ℚ := interpQ 17279915862 [257310604295690, 514621208591380, 623482755139778, 783769752440859, 678585850512621, 412078701188873, 203154758954428, -171412114460254, -387050642116553, -391950190440753, -415437487598378, -707110167881356, -998782848164334, -1131131691870357, -1296318237495638, -1176496858337397, -879671813383930, -635160773930703, -230276004886302]
theorem CV_101_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_101 - CV_2_im_000 * Fplus_dW_im_101 = CV_101_2_pre := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_101_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_101_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_101 + CV_2_im_000 * Fplus_dW_re_101 = CV_101_2_pim := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_101_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_101_2_mul :
    CV_2_c_000 * Fplus_dW_c_101 = ofLadj CV_101_2_pre CV_101_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_101_def, ofLadj_mul, CV_101_2_pre_eq, CV_101_2_pim_eq]

def CV_101_3_pre : Polynomial ℚ := interpQ 17279915862 [2271610588060, 0, -5082061147020, -12222932350310, -18405077262154, -22231838383106, -22231838383106, -18405077262154, -12222932350310, -5082061147020]
def CV_101_3_pim : Polynomial ℚ := interpQ 17279915862 [6738891906184, 13477783812368, 18072823625884, 18991273123254, 16133134443746, 10185507722862, 3292276089506, -2655350631378, -5513489310886, -4595039813516]
theorem CV_101_3_neg_re : -CV_3_re_101 = CV_101_3_pre := by
  simp only [CV_3_re_101_def, CV_101_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_101_3_neg_im : -CV_3_im_101 = CV_101_3_pim := by
  simp only [CV_3_im_101_def, CV_101_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_101_3_mul : -CV_3_c_101 = ofLadj CV_101_3_pre CV_101_3_pim := by
  rw [CV_3_c_101_def, ofLadj_neg, CV_101_3_neg_re, CV_101_3_neg_im]

@[expose] public def CV_coeff_101 : Ki := CV_0_c_000 * Fplus_dU_c_101 + CV_1_c_000 * Fplus_dV_c_101 + CV_2_c_000 * Fplus_dW_c_101 + (-CV_3_c_101)

theorem CV_coeff_101_sum :
    CV_coeff_101 = ofLadj (CV_101_0_pre + CV_101_1_pre + CV_101_2_pre + CV_101_3_pre) (CV_101_0_pim + CV_101_1_pim + CV_101_2_pim + CV_101_3_pim) := by
  simp only [CV_coeff_101, CV_101_0_mul, CV_101_1_mul, CV_101_2_mul, CV_101_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_101_0_pre CV_101_0_pim CV_101_1_pre CV_101_1_pim CV_101_2_pre CV_101_2_pim CV_101_3_pre CV_101_3_pim

def CV_101_qre : Polynomial ℚ := interpQ 17279915862 [14415726745056, -390047588569552, -455730980260498, -595089611348436, -835218245556695, -553033901905646, -505659303241005, -330466893676916, 19412294974008]
def CV_101_qim : Polynomial ℚ := interpQ 17279915862 [392677395728862, 392677395728862, 273196333053498, 314119528923372, -36178876515283, -269790776478104, -232316509215797, -478270559706206, -284992966550174]
theorem CV_coeff_101_poly_re :
    CV_101_0_pre + CV_101_1_pre + CV_101_2_pre + CV_101_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_101_qre := by
  rw [phi11_interpQ]
  simp only [CV_101_0_pre, CV_101_1_pre, CV_101_2_pre, CV_101_3_pre, CV_101_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_101_poly_im :
    CV_101_0_pim + CV_101_1_pim + CV_101_2_pim + CV_101_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_101_qim := by
  rw [phi11_interpQ]
  simp only [CV_101_0_pim, CV_101_1_pim, CV_101_2_pim, CV_101_3_pim, CV_101_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_101_eq :
    CV_coeff_101 = (0 : Ki) := by
  rw [CV_coeff_101_sum, CV_coeff_101_poly_re,
    CV_coeff_101_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
