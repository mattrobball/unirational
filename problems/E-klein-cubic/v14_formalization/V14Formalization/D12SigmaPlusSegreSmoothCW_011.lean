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

def CW_011_0_pre : Polynomial ℚ := interpQ 8639957931 [4173517992179, 62693770046300, 126904485566572, 210172095176315, 313108948975648, 370926107832863, 419844629020409, 444928937821908, 423514941236660, 415496083166293, 409359282811977, 402822675853925, 346665512765677, 288591597599721, 213342846060345, 117777388157269, 64435286205883, 15516765018337, -14042600688991]
def CW_011_0_pim : Polynomial ℚ := interpQ 8639957931 [-42407897244195, -84815794488390, -100591745273060, -119553213551535, -88606586962300, -31639968065050, 15073976038078, 84399322604757, 123002895954309, 121836825378143, 116568535621518, 151141305853455, 185714076085392, 196221737113437, 214017134815746, 186419725537780, 136253325794909, 97779483450583, 35254356038283]
theorem CW_011_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_011 - CW_0_im_000 * Fplus_dU_im_011 = CW_011_0_pre := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_011_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_011_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_011 + CW_0_im_000 * Fplus_dU_re_011 = CW_011_0_pim := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_011_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_011_0_mul :
    CW_0_c_000 * Fplus_dU_c_011 = ofLadj CW_011_0_pre CW_011_0_pim := by
  rw [CW_0_c_000_def, Fplus_dU_c_011_def, ofLadj_mul, CW_011_0_pre_eq, CW_011_0_pim_eq]

def CW_011_1_pre : Polynomial ℚ := interpQ 8639957931 [-6773039452682, -121659329137640, -239768581441736, -392906653983064, -587857879966121, -698088019895540, -791572453405688, -845552126765595, -806187861215062, -796836493699239, -790151694345321, -780474783343704, -668492365207681, -557067912257503, -413281207231998, -226544008965981, -121397281892348, -27912848382200, 31150237833493]
def CW_011_1_pim : Polynomial ℚ := interpQ 8639957931 [83599448562598, 167198897125196, 193532992952051, 235643923017955, 179671489570603, 71274783782756, -17089067231004, -150576750126439, -228354764231313, -226788546481231, -220778391585616, -295569085352698, -370359779119780, -390683720051020, -431228432366842, -379460081982892, -278539335633842, -199585654498110, -73573931041472]
theorem CW_011_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_011 - CW_1_im_000 * Fplus_dV_im_011 = CW_011_1_pre := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_011_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_011_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_011 + CW_1_im_000 * Fplus_dV_re_011 = CW_011_1_pim := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_011_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_011_1_mul :
    CW_1_c_000 * Fplus_dV_c_011 = ofLadj CW_011_1_pre CW_011_1_pim := by
  rw [CW_1_c_000_def, Fplus_dV_c_011_def, ofLadj_mul, CW_011_1_pre_eq, CW_011_1_pim_eq]

def CW_011_2_pre : Polynomial ℚ := interpQ 8639957931 [-107316825614, 4295397661640, 9121593470118, 15886185164186, 25100350439150, 32272094548454, 38236184763867, 40000729903697, 36068281433396, 33231826103884, 31264719347116, 30698930927526, 26969321685476, 24110232633766, 20182096269210, 13490759275675, 7676621686044, 1712531470631, -1409620188872]
def CW_011_2_pim : Polynomial ℚ := interpQ 8639957931 [-4590689221896, -9181378443792, -11524059421830, -14578833644705, -14071481843247, -10068318834060, -4301558975822, 3873065494853, 8315834112098, 7872290132550, 6017056053312, 8047164585066, 10077273116820, 10564720015620, 13175950258947, 13889367096110, 12189701535117, 9093127001105, 3221999978624]
theorem CW_011_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_011 - CW_2_im_000 * Fplus_dW_im_011 = CW_011_2_pre := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_011_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_011_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_011 + CW_2_im_000 * Fplus_dW_re_011 = CW_011_2_pim := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_011_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_011_2_mul :
    CW_2_c_000 * Fplus_dW_c_011 = ofLadj CW_011_2_pre CW_011_2_pim := by
  rw [CW_2_c_000_def, Fplus_dW_c_011_def, ofLadj_mul, CW_011_2_pre_eq, CW_011_2_pim_eq]

def CW_011_3_pre : Polynomial ℚ := interpQ 8639957931 [132322662142, 0, -1419107757166, -2923053641222, -4603250101868, -5352500671584, -5352500671584, -4603250101868, -2923053641222, -1419107757166]
def CW_011_3_pim : Polynomial ℚ := interpQ 8639957931 [1586952906884, 3173905813768, 4287274754016, 4330671559648, 3964768673160, 2337011509384, 836894304384, -790862859392, -1156765745880, -1113368940248]
theorem CW_011_3_neg_re : -CW_3_re_011 = CW_011_3_pre := by
  simp only [CW_3_re_011_def, CW_011_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_011_3_neg_im : -CW_3_im_011 = CW_011_3_pim := by
  simp only [CW_3_im_011_def, CW_011_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_011_3_mul : -CW_3_c_011 = ofLadj CW_011_3_pre CW_011_3_pim := by
  rw [CW_3_c_011_def, ofLadj_neg, CW_011_3_neg_re, CW_011_3_neg_im]

@[expose] public def CW_coeff_011 : Ki := CW_0_c_000 * Fplus_dU_c_011 + CW_1_c_000 * Fplus_dV_c_011 + CW_2_c_000 * Fplus_dW_c_011 + (-CW_3_c_011)

theorem CW_coeff_011_sum :
    CW_coeff_011 = ofLadj (CW_011_0_pre + CW_011_1_pre + CW_011_2_pre + CW_011_3_pre) (CW_011_0_pim + CW_011_1_pim + CW_011_2_pim + CW_011_3_pim) := by
  simp only [CW_coeff_011, CW_011_0_mul, CW_011_1_mul, CW_011_2_mul, CW_011_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_011_0_pre CW_011_0_pim CW_011_1_pre CW_011_1_pim CW_011_2_pre CW_011_2_pim CW_011_3_pre CW_011_3_pim

def CW_011_qre : Polynomial ℚ := interpQ 8639957931 [-2574515623975, -52095645805725, -50491448732512, -64609817121573, -84480403369406, -45990487532616, -38601822107189, -26381568848862, 15698016955630]
def CW_011_qim : Polynomial ℚ := interpQ 8639957931 [38187815003391, 38187815003391, 9328833004395, 20138084370186, -24884357943147, -49054681045186, -37383264257394, -57615469021857, -35097575024565]
theorem CW_coeff_011_poly_re :
    CW_011_0_pre + CW_011_1_pre + CW_011_2_pre + CW_011_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_011_qre := by
  rw [phi11_interpQ]
  simp only [CW_011_0_pre, CW_011_1_pre, CW_011_2_pre, CW_011_3_pre, CW_011_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_011_poly_im :
    CW_011_0_pim + CW_011_1_pim + CW_011_2_pim + CW_011_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_011_qim := by
  rw [phi11_interpQ]
  simp only [CW_011_0_pim, CW_011_1_pim, CW_011_2_pim, CW_011_3_pim, CW_011_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_011_eq :
    CW_coeff_011 = (0 : Ki) := by
  rw [CW_coeff_011_sum, CW_coeff_011_poly_re,
    CW_coeff_011_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
