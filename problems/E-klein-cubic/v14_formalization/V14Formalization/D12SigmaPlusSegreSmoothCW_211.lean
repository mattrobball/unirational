/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CW_211_0_pre : Polynomial ℚ := C ((-308256000368 / 2879985977 : ℚ)) + C ((-4213593231136 / 2879985977 : ℚ)) * X + C ((-22169225598394 / 8639957931 : ℚ)) * X ^ 2 + C ((-36037088742305 / 8639957931 : ℚ)) * X ^ 3 + C ((-17605062338456 / 2879985977 : ℚ)) * X ^ 4 + C ((-57594739898228 / 8639957931 : ℚ)) * X ^ 5 + C ((-22084696823587 / 2879985977 : ℚ)) * X ^ 6 + C ((-6064739791889 / 785450721 : ℚ)) * X ^ 7 + C ((-61950608227121 / 8639957931 : ℚ)) * X ^ 8 + C ((-20373530741285 / 2879985977 : ℚ)) * X ^ 9 + C ((-20092436148856 / 2879985977 : ℚ)) * X ^ 10 + C ((-1793349371702 / 261816907 : ℚ)) * X ^ 11 + C ((-15878842917720 / 2879985977 : ℚ)) * X ^ 12 + C ((-38951366625461 / 8639957931 : ℚ)) * X ^ 13 + C ((-8637839828272 / 2879985977 : ℚ)) * X ^ 14 + C ((-3381796639017 / 2879985977 : ℚ)) * X ^ 15 + C ((-5839395162362 / 8639957931 : ℚ)) * X ^ 16 + C ((2819955410171 / 8639957931 : ℚ)) * X ^ 17 + C ((3751560778360 / 8639957931 : ℚ)) * X ^ 18
def CW_211_0_pim : Polynomial ℚ := C ((6230576999860 / 8639957931 : ℚ)) + C ((12461153999720 / 8639957931 : ℚ)) * X + C ((333358672062 / 261816907 : ℚ)) * X ^ 2 + C ((4664353090382 / 2879985977 : ℚ)) * X ^ 3 + C ((1229879398904 / 2879985977 : ℚ)) * X ^ 4 + C ((-6118258405079 / 8639957931 : ℚ)) * X ^ 5 + C ((-4923660853086 / 2879985977 : ℚ)) * X ^ 6 + C ((-9241579105290 / 2879985977 : ℚ)) * X ^ 7 + C ((-10733827562609 / 2879985977 : ℚ)) * X ^ 8 + C ((-2926576434961 / 785450721 : ℚ)) * X ^ 9 + C ((-10496001175419 / 2879985977 : ℚ)) * X ^ 10 + C ((-36804099680212 / 8639957931 : ℚ)) * X ^ 11 + C ((-3829108712197 / 785450721 : ℚ)) * X ^ 12 + C ((-39955540754179 / 8639957931 : ℚ)) * X ^ 13 + C ((-14312873981341 / 2879985977 : ℚ)) * X ^ 14 + C ((-32873177207734 / 8639957931 : ℚ)) * X ^ 15 + C ((-23990774890688 / 8639957931 : ℚ)) * X ^ 16 + C ((-16267029505679 / 8639957931 : ℚ)) * X ^ 17 + C ((-4238769033812 / 8639957931 : ℚ)) * X ^ 18
theorem CW_211_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_101 - CW_0_im_110 * Fplus_dU_im_101 = CW_211_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_101, Fplus_dU_im_101, CW_211_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_211_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_101 + CW_0_im_110 * Fplus_dU_re_101 = CW_211_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_101, Fplus_dU_im_101, CW_211_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_211_0_mul :
    CW_0_c_110 * Fplus_dU_c_101 = ofLadj CW_211_0_pre CW_211_0_pim := by
  rw [CW_0_c_110, Fplus_dU_c_101, ofLadj_mul, CW_211_0_pre_eq, CW_211_0_pim_eq]

def CW_211_1_pre : Polynomial ℚ := C ((-203796652095 / 2879985977 : ℚ)) + C ((2546072398740 / 2879985977 : ℚ)) * X + C ((14047562375557 / 8639957931 : ℚ)) * X ^ 2 + C ((24175620764105 / 8639957931 : ℚ)) * X ^ 3 + C ((12280962334453 / 2879985977 : ℚ)) * X ^ 4 + C ((13963117014763 / 2879985977 : ℚ)) * X ^ 5 + C ((16420586321019 / 2879985977 : ℚ)) * X ^ 6 + C ((4660553719681 / 785450721 : ℚ)) * X ^ 7 + C ((16256300860721 / 2879985977 : ℚ)) * X ^ 8 + C ((47791543229039 / 8639957931 : ℚ)) * X ^ 9 + C ((47090654850101 / 8639957931 : ℚ)) * X ^ 10 + C ((47336471925185 / 8639957931 : ℚ)) * X ^ 11 + C ((39452437653881 / 8639957931 : ℚ)) * X ^ 12 + C ((33743980853482 / 8639957931 : ℚ)) * X ^ 13 + C ((24593281818058 / 8639957931 : ℚ)) * X ^ 14 + C ((4250033193482 / 2879985977 : ℚ)) * X ^ 15 + C ((8254590937630 / 8639957931 : ℚ)) * X ^ 16 + C ((882183018862 / 8639957931 : ℚ)) * X ^ 17 + C ((-1673104332686 / 8639957931 : ℚ)) * X ^ 18
def CW_211_1_pim : Polynomial ℚ := C ((-170706780529 / 261816907 : ℚ)) + C ((-341413561058 / 261816907 : ℚ)) * X + C ((-12168079313567 / 8639957931 : ℚ)) * X ^ 2 + C ((-16486419387101 / 8639957931 : ℚ)) * X ^ 3 + C ((-11087333593483 / 8639957931 : ℚ)) * X ^ 4 + C ((-5682971713346 / 8639957931 : ℚ)) * X ^ 5 + C ((-664306874332 / 8639957931 : ℚ)) * X ^ 6 + C ((2688238862609 / 2879985977 : ℚ)) * X ^ 7 + C ((3960517639371 / 2879985977 : ℚ)) * X ^ 8 + C ((3907341014499 / 2879985977 : ℚ)) * X ^ 9 + C ((11122587306890 / 8639957931 : ℚ)) * X ^ 10 + C ((15807347381341 / 8639957931 : ℚ)) * X ^ 11 + C ((6830702485264 / 2879985977 : ℚ)) * X ^ 12 + C ((20794103517838 / 8639957931 : ℚ)) * X ^ 13 + C ((24952913716756 / 8639957931 : ℚ)) * X ^ 14 + C ((6670494246564 / 2879985977 : ℚ)) * X ^ 15 + C ((15348371027240 / 8639957931 : ℚ)) * X ^ 16 + C ((3782318269402 / 2879985977 : ℚ)) * X ^ 17 + C ((9253943564 / 23801537 : ℚ)) * X ^ 18
theorem CW_211_1_pre_eq :
    CW_1_re_110 * Fplus_dV_re_101 - CW_1_im_110 * Fplus_dV_im_101 = CW_211_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_101, Fplus_dV_im_101, CW_211_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_211_1_pim_eq :
    CW_1_re_110 * Fplus_dV_im_101 + CW_1_im_110 * Fplus_dV_re_101 = CW_211_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_101, Fplus_dV_im_101, CW_211_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_211_1_mul :
    CW_1_c_110 * Fplus_dV_c_101 = ofLadj CW_211_1_pre CW_211_1_pim := by
  rw [CW_1_c_110, Fplus_dV_c_101, ofLadj_mul, CW_211_1_pre_eq, CW_211_1_pim_eq]

def CW_211_2_pre : Polynomial ℚ := C ((-9901802648 / 32359393 : ℚ)) + C ((-4455006416 / 32359393 : ℚ)) * X + C ((-61269939872 / 97078179 : ℚ)) * X ^ 2 + C ((-25389635649 / 32359393 : ℚ)) * X ^ 3 + C ((-88407983398 / 97078179 : ℚ)) * X ^ 4 + C ((-149658517717 / 97078179 : ℚ)) * X ^ 5 + C ((-127091312687 / 97078179 : ℚ)) * X ^ 6 + C ((-53683636298 / 32359393 : ℚ)) * X ^ 7 + C ((-165208790614 / 97078179 : ℚ)) * X ^ 8 + C ((-164501269832 / 97078179 : ℚ)) * X ^ 9 + C ((-167575570573 / 97078179 : ℚ)) * X ^ 10 + C ((-135744263108 / 97078179 : ℚ)) * X ^ 11 + C ((-154210551325 / 97078179 : ℚ)) * X ^ 12 + C ((-3128222120 / 2941763 : ℚ)) * X ^ 13 + C ((-89039883667 / 97078179 : ℚ)) * X ^ 14 + C ((-24436263932 / 32359393 : ℚ)) * X ^ 15 + C ((-12217330010 / 97078179 : ℚ)) * X ^ 16 + C ((-34784535040 / 97078179 : ℚ)) * X ^ 17 + C ((-60533300 / 8825289 : ℚ)) * X ^ 18
def CW_211_2_pim : Polynomial ℚ := C ((-553642710 / 32359393 : ℚ)) + C ((-1107285420 / 32359393 : ℚ)) * X + C ((24858153772 / 97078179 : ℚ)) * X ^ 2 + C ((-17607402245 / 97078179 : ℚ)) * X ^ 3 + C ((6051609444 / 32359393 : ℚ)) * X ^ 4 + C ((-22790603111 / 97078179 : ℚ)) * X ^ 5 + C ((-43279918571 / 97078179 : ℚ)) * X ^ 6 + C ((-42391162669 / 97078179 : ℚ)) * X ^ 7 + C ((-75514932226 / 97078179 : ℚ)) * X ^ 8 + C ((-73733909396 / 97078179 : ℚ)) * X ^ 9 + C ((-75905673133 / 97078179 : ℚ)) * X ^ 10 + C ((-75153543016 / 97078179 : ℚ)) * X ^ 11 + C ((-6763764809 / 8825289 : ℚ)) * X ^ 12 + C ((-104753186668 / 97078179 : ℚ)) * X ^ 13 + C ((-5500600711 / 8825289 : ℚ)) * X ^ 14 + C ((-98555714947 / 97078179 : ℚ)) * X ^ 15 + C ((-54010110052 / 97078179 : ℚ)) * X ^ 16 + C ((-11182770186 / 32359393 : ℚ)) * X ^ 17 + C ((-10278964336 / 32359393 : ℚ)) * X ^ 18
theorem CW_211_2_pre_eq :
    CW_2_re_110 * Fplus_dW_re_101 - CW_2_im_110 * Fplus_dW_im_101 = CW_211_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_101, Fplus_dW_im_101, CW_211_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_211_2_pim_eq :
    CW_2_re_110 * Fplus_dW_im_101 + CW_2_im_110 * Fplus_dW_re_101 = CW_211_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_101, Fplus_dW_im_101, CW_211_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_211_2_mul :
    CW_2_c_110 * Fplus_dW_c_101 = ofLadj CW_211_2_pre CW_211_2_pim := by
  rw [CW_2_c_110, Fplus_dW_c_101, ofLadj_mul, CW_211_2_pre_eq, CW_211_2_pim_eq]

theorem CW_211_3_mul : CW_3_c_210 = ofLadj CW_3_re_210 CW_3_im_210 := rfl

@[expose] public def CW_coeff_211 : Ki := CW_0_c_110 * Fplus_dU_c_101 + CW_1_c_110 * Fplus_dV_c_101 + CW_2_c_110 * Fplus_dW_c_101 + CW_3_c_210

theorem CW_coeff_211_sum :
    CW_coeff_211 = ofLadj (CW_211_0_pre + CW_211_1_pre + CW_211_2_pre + CW_3_re_210) (CW_211_0_pim + CW_211_1_pim + CW_211_2_pim + CW_3_im_210) := by
  simp only [CW_coeff_211, CW_211_0_mul, CW_211_1_mul, CW_211_2_mul, CW_211_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_211_0_pre CW_211_0_pim CW_211_1_pre CW_211_1_pim CW_211_2_pre CW_211_2_pim CW_3_re_210 CW_3_im_210

def CW_211_qre : Polynomial ℚ := C ((-4175582619871 / 8639957931 : ℚ)) + C ((-2016466590389 / 8639957931 : ℚ)) * X + C ((-7513856028785 / 8639957931 : ℚ)) * X ^ 2 + C ((-1716728941766 / 2879985977 : ℚ)) * X ^ 3 + C ((-5325014506672 / 8639957931 : ℚ)) * X ^ 4 + C ((-477056928257 / 785450721 : ℚ)) * X ^ 5 + C ((240512864635 / 2879985977 : ℚ)) * X ^ 6 + C ((-1412879534501 / 8639957931 : ℚ)) * X ^ 7 + C ((673064781658 / 2879985977 : ℚ)) * X ^ 8
def CW_211_qim : Polynomial ℚ := C ((564396499091 / 8639957931 : ℚ)) + C ((564396499091 / 8639957931 : ℚ)) * X + C ((234656723407 / 8639957931 : ℚ)) * X ^ 2 + C ((-5113674526457 / 8639957931 : ℚ)) * X ^ 3 + C ((-579214408337 / 2879985977 : ℚ)) * X ^ 4 + C ((-8183849440249 / 8639957931 : ℚ)) * X ^ 5 + C ((-1847809773647 / 2879985977 : ℚ)) * X ^ 6 + C ((-1427267779781 / 2879985977 : ℚ)) * X ^ 7 + C ((-3624070997792 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_211_poly_re :
    CW_211_0_pre + CW_211_1_pre + CW_211_2_pre + CW_3_re_210 = (0 : Polynomial ℚ) + Phi11 * CW_211_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_211_0_pre, CW_211_1_pre, CW_211_2_pre, CW_3_re_210, CW_211_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_211_poly_im :
    CW_211_0_pim + CW_211_1_pim + CW_211_2_pim + CW_3_im_210 = (0 : Polynomial ℚ) + Phi11 * CW_211_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_211_0_pim, CW_211_1_pim, CW_211_2_pim, CW_3_im_210, CW_211_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_211_eq :
    CW_coeff_211 = (0 : Ki) := by
  rw [CW_coeff_211_sum, CW_coeff_211_poly_re,
    CW_coeff_211_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
