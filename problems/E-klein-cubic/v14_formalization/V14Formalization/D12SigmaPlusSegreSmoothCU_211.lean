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

def CU_211_0_pre : Polynomial ℚ := interpQ 235794999 [-44807076710028, 0, 39481859489136, 112828451385972, 347597138009724, 583761160384152, 826438892216412, 1023914729708550, 1098696807574140, 1130590620432126, 1154941322284998, 1208851071480852, 1154941322284998, 1091108760942990, 985868356188168, 721797714026754, 468193241189190, 225515509356930, 45480122327928]
def CU_211_0_pim : Polynomial ℚ := interpQ 235794999 [-152495282834316, -304990565668632, -495648038152236, -754374497152488, -914521261037112, -990750789335952, -1011122531917068, -864214600441722, -768250150488378, -763661398507794, -742575951629706, -559149370392492, -375722789155278, -163979869793586, 99335341187250, 246098458168974, 295232562535266, 283351452264138, 109348096856244]
theorem CU_211_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_200 - CU_0_im_011 * Fplus_dU_im_200 = CU_211_0_pre := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_211_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_211_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_200 + CU_0_im_011 * Fplus_dU_re_200 = CU_211_0_pim := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_211_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_211_0_mul :
    CU_0_c_011 * Fplus_dU_c_200 = ofLadj CU_211_0_pre CU_211_0_pim := by
  rw [CU_0_c_011_def, Fplus_dU_c_200_def, ofLadj_mul, CU_211_0_pre_eq, CU_211_0_pim_eq]

def CU_211_1_pre : Polynomial ℚ := interpQ 235794999 [-832470887276, 121142661053008, 242273306770718, 394779163335928, 667416719329612, 854465304565662, 1030392677845440, 1107020021324154, 1030452421466932, 975640416795386, 933808955107090, 919026208486324, 812666294054082, 733367110024668, 635673258131004, 413390516059664, 256282471924374, 80355098644596, -26212785934878]
def CU_211_1_pim : Polynomial ℚ := interpQ 235794999 [-114890724464390, -229781448928780, -297014541511702, -407420736422886, -409846640908080, -300946360679684, -180356695383798, 50910416256278, 176505292151960, 168617307085308, 132368056264282, 194130774784684, 255893493305086, 286877335066982, 389395544911514, 414831436193066, 352494308856504, 287288847847566, 102584889099324]
theorem CU_211_1_pre_eq :
    CU_1_re_011 * Fplus_dV_re_200 - CU_1_im_011 * Fplus_dV_im_200 = CU_211_1_pre := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_211_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_211_1_pim_eq :
    CU_1_re_011 * Fplus_dV_im_200 + CU_1_im_011 * Fplus_dV_re_200 = CU_211_1_pim := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_211_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_211_1_mul :
    CU_1_c_011 * Fplus_dV_c_200 = ofLadj CU_211_1_pre CU_211_1_pim := by
  rw [CU_1_c_011_def, Fplus_dV_c_200_def, ofLadj_mul, CU_211_1_pre_eq, CU_211_1_pim_eq]

def CU_211_2_pre : Polynomial ℚ := interpQ 235794999 [-36994005448600, -264250456343872, -498192618884560, -783268050823766, -1115142768568232, -1278465282610268, -1399314407028984, -1455725582767918, -1348587284778600, -1328133589098216, -1312540846249340, -1269727986777360, -1048290389905468, -829940970213656, -565319233954834, -252225685304366, -100059939980806, 20789184437910, 88357128895320]
def CU_211_2_pim : Polynomial ℚ := interpQ 235794999 [118472993553864, 236945987107728, 225363038408728, 224558435004958, 61284760316852, -192338236724608, -386418690007726, -633443531455846, -770482641871120, -767534740966752, -754008025193910, -852673389205304, -951338753216698, -926229088744856, -922476584436718, -767796686976798, -531538147492232, -358105717078314, -128445333187088]
theorem CU_211_2_pre_eq :
    CU_2_re_011 * Fplus_dW_re_200 - CU_2_im_011 * Fplus_dW_im_200 = CU_211_2_pre := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_211_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_211_2_pim_eq :
    CU_2_re_011 * Fplus_dW_im_200 + CU_2_im_011 * Fplus_dW_re_200 = CU_211_2_pim := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_211_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_211_2_mul :
    CU_2_c_011 * Fplus_dW_c_200 = ofLadj CU_211_2_pre CU_211_2_pim := by
  rw [CU_2_c_011_def, Fplus_dW_c_200_def, ofLadj_mul, CU_211_2_pre_eq, CU_211_2_pim_eq]

theorem CU_211_3_mul : CU_3_c_111 = ofLadj CU_3_re_111 CU_3_im_111 := CU_3_c_111_def

@[expose] public def CU_coeff_211 : Ki := CU_0_c_011 * Fplus_dU_c_200 + CU_1_c_011 * Fplus_dV_c_200 + CU_2_c_011 * Fplus_dW_c_200 + CU_3_c_111

theorem CU_coeff_211_sum :
    CU_coeff_211 = ofLadj (CU_211_0_pre + CU_211_1_pre + CU_211_2_pre + CU_3_re_111) (CU_211_0_pim + CU_211_1_pim + CU_211_2_pim + CU_3_im_111) := by
  simp only [CU_coeff_211, CU_211_0_mul, CU_211_1_mul, CU_211_2_mul, CU_211_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_211_0_pre CU_211_0_pim CU_211_1_pre CU_211_1_pim CU_211_2_pre CU_211_2_pim CU_3_re_111 CU_3_im_111

def CU_211_qre : Polynomial ℚ := interpQ 235794999 [-81939862047068, -61167933243796, -75217674320390, -61687479610336, 173259835582286, 258546771649294, 297755980693322, 219035327151066, 107624465288370]
def CU_211_qim : Polynomial ℚ := interpQ 235794999 [-146523935746222, -146523935746222, -267836425595430, -369585925133506, -326878905723196, -223055516514296, -96345859133852, 129046930264910, 83487652768480]
theorem CU_coeff_211_poly_re :
    CU_211_0_pre + CU_211_1_pre + CU_211_2_pre + CU_3_re_111 = (0 : Polynomial ℚ) + Phi11 * CU_211_qre := by
  rw [phi11_interpQ]
  simp only [CU_211_0_pre, CU_211_1_pre, CU_211_2_pre, CU_3_re_111_def, CU_211_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_211_poly_im :
    CU_211_0_pim + CU_211_1_pim + CU_211_2_pim + CU_3_im_111 = (0 : Polynomial ℚ) + Phi11 * CU_211_qim := by
  rw [phi11_interpQ]
  simp only [CU_211_0_pim, CU_211_1_pim, CU_211_2_pim, CU_3_im_111_def, CU_211_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_211_eq :
    CU_coeff_211 = (0 : Ki) := by
  rw [CU_coeff_211_sum, CU_coeff_211_poly_re,
    CU_coeff_211_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
