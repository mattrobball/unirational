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

def CU_004_0_pre : Polynomial ℚ := C ((-29933808877160 / 21435909 : ℚ)) + C ((-5373980060980384 / 235794999 : ℚ)) * X + C ((-3576296646125312 / 78598333 : ℚ)) * X ^ 2 + C ((-17423131425522400 / 235794999 : ℚ)) * X ^ 3 + C ((-26473543365852136 / 235794999 : ℚ)) * X ^ 4 + C ((-2909302451594920 / 21435909 : ℚ)) * X ^ 5 + C ((-37049081186040152 / 235794999 : ℚ)) * X ^ 6 + C ((-13469716471876336 / 78598333 : ℚ)) * X ^ 7 + C ((-39730208294273680 / 235794999 : ℚ)) * X ^ 8 + C ((-40263637027380632 / 235794999 : ℚ)) * X ^ 9 + C ((-13556954831389208 / 78598333 : ℚ)) * X ^ 10 + C ((-1227072451350928 / 7145303 : ℚ)) * X ^ 11 + C ((-35296884433187240 / 235794999 : ℚ)) * X ^ 12 + C ((-2684977008091336 / 21435909 : ℚ)) * X ^ 13 + C ((-7435692289583760 / 78598333 : ℚ)) * X ^ 14 + C ((-12766479822347224 / 235794999 : ℚ)) * X ^ 15 + C ((-6946391029947320 / 235794999 : ℚ)) * X ^ 16 + C ((-1899636811451288 / 235794999 : ℚ)) * X ^ 17 + C ((1169126227429648 / 235794999 : ℚ)) * X ^ 18
def CU_004_0_pim : Polynomial ℚ := C ((3849121569060568 / 235794999 : ℚ)) + C ((7698243138121136 / 235794999 : ℚ)) * X + C ((3128001426216720 / 78598333 : ℚ)) * X ^ 2 + C ((11721412543162232 / 235794999 : ℚ)) * X ^ 3 + C ((10180196158627184 / 235794999 : ℚ)) * X ^ 4 + C ((6125979316113640 / 235794999 : ℚ)) * X ^ 5 + C ((995555595066672 / 78598333 : ℚ)) * X ^ 6 + C ((-2665574058157544 / 235794999 : ℚ)) * X ^ 7 + C ((-5928632419072424 / 235794999 : ℚ)) * X ^ 8 + C ((-6005341355059480 / 235794999 : ℚ)) * X ^ 9 + C ((-6358256928902000 / 235794999 : ℚ)) * X ^ 10 + C ((-3574801238445312 / 78598333 : ℚ)) * X ^ 11 + C ((-15090550501769872 / 235794999 : ℚ)) * X ^ 12 + C ((-5709742405380472 / 78598333 : ℚ)) * X ^ 13 + C ((-19543344416640544 / 235794999 : ℚ)) * X ^ 14 + C ((-17778229673492488 / 235794999 : ℚ)) * X ^ 15 + C ((-13270684273509248 / 235794999 : ℚ)) * X ^ 16 + C ((-3197508706785048 / 78598333 : ℚ)) * X ^ 17 + C ((-1162318906509296 / 78598333 : ℚ)) * X ^ 18
theorem CU_004_0_pre_eq :
    CU_0_re_002 * Fplus_dU_re_002 - CU_0_im_002 * Fplus_dU_im_002 = CU_004_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_004_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_004_0_pim_eq :
    CU_0_re_002 * Fplus_dU_im_002 + CU_0_im_002 * Fplus_dU_re_002 = CU_004_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_004_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_004_0_mul :
    CU_0_c_002 * Fplus_dU_c_002 = ofLadj CU_004_0_pre CU_004_0_pim := by
  rw [CU_0_c_002_def, Fplus_dU_c_002_def, ofLadj_mul, CU_004_0_pre_eq, CU_004_0_pim_eq]

def CU_004_1_pre : Polynomial ℚ := C ((25307304206216 / 235794999 : ℚ)) + C ((-193353065220640 / 78598333 : ℚ)) * X + C ((-1238336663979880 / 235794999 : ℚ)) * X ^ 2 + C ((-2116041549196192 / 235794999 : ℚ)) * X ^ 3 + C ((-3369231462912712 / 235794999 : ℚ)) * X ^ 4 + C ((-132106005368528 / 7145303 : ℚ)) * X ^ 5 + C ((-5134135539831832 / 235794999 : ℚ)) * X ^ 6 + C ((-5363436516988640 / 235794999 : ℚ)) * X ^ 7 + C ((-4846886339395024 / 235794999 : ℚ)) * X ^ 8 + C ((-1494533693040264 / 78598333 : ℚ)) * X ^ 9 + C ((-4206234929753864 / 235794999 : ℚ)) * X ^ 10 + C ((-1376047104898416 / 78598333 : ℚ)) * X ^ 11 + C ((-329652339462904 / 21435909 : ℚ)) * X ^ 12 + C ((-3245264415140912 / 235794999 : ℚ)) * X ^ 13 + C ((-910281596732944 / 78598333 : ℚ)) * X ^ 14 + C ((-1811504867449280 / 235794999 : ℚ)) * X ^ 15 + C ((-92696546912312 / 21435909 : ℚ)) * X ^ 16 + C ((-81674884455008 / 78598333 : ℚ)) * X ^ 17 + C ((182700186626648 / 235794999 : ℚ)) * X ^ 18
def CU_004_1_pim : Polynomial ℚ := C ((622639721442344 / 235794999 : ℚ)) + C ((1245279442884688 / 235794999 : ℚ)) * X + C ((1544225461984736 / 235794999 : ℚ)) * X ^ 2 + C ((1960028141755472 / 235794999 : ℚ)) * X ^ 3 + C ((1920437475076792 / 235794999 : ℚ)) * X ^ 4 + C ((451549486650024 / 78598333 : ℚ)) * X ^ 5 + C ((573458025341896 / 235794999 : ℚ)) * X ^ 6 + C ((-502516701455416 / 235794999 : ℚ)) * X ^ 7 + C ((-365537647567016 / 78598333 : ℚ)) * X ^ 8 + C ((-1044379219874608 / 235794999 : ℚ)) * X ^ 9 + C ((-2214969706928 / 649573 : ℚ)) * X ^ 10 + C ((-1074524042723696 / 235794999 : ℚ)) * X ^ 11 + C ((-1345014081832528 / 235794999 : ℚ)) * X ^ 12 + C ((-1403614884672832 / 235794999 : ℚ)) * X ^ 13 + C ((-160653076510648 / 21435909 : ℚ)) * X ^ 14 + C ((-1880063867072104 / 235794999 : ℚ)) * X ^ 15 + C ((-1623025033825576 / 235794999 : ℚ)) * X ^ 16 + C ((-402950031343032 / 78598333 : ℚ)) * X ^ 17 + C ((-441625549111976 / 235794999 : ℚ)) * X ^ 18
theorem CU_004_1_pre_eq :
    CU_1_re_002 * Fplus_dV_re_002 - CU_1_im_002 * Fplus_dV_im_002 = CU_004_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_004_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_004_1_pim_eq :
    CU_1_re_002 * Fplus_dV_im_002 + CU_1_im_002 * Fplus_dV_re_002 = CU_004_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_004_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_004_1_mul :
    CU_1_c_002 * Fplus_dV_c_002 = ofLadj CU_004_1_pre CU_004_1_pim := by
  rw [CU_1_c_002_def, Fplus_dV_c_002_def, ofLadj_mul, CU_004_1_pre_eq, CU_004_1_pim_eq]

def CU_004_2_pre : Polynomial ℚ := C ((16132459598976 / 78598333 : ℚ)) + C ((-43287105806688 / 78598333 : ℚ)) * X ^ 2 + C ((-100001596750928 / 78598333 : ℚ)) * X ^ 3 + C ((-152113301786712 / 78598333 : ℚ)) * X ^ 4 + C ((-183073744411064 / 78598333 : ℚ)) * X ^ 5 + C ((-183073744411064 / 78598333 : ℚ)) * X ^ 6 + C ((-152113301786712 / 78598333 : ℚ)) * X ^ 7 + C ((-100001596750928 / 78598333 : ℚ)) * X ^ 8 + C ((-43287105806688 / 78598333 : ℚ)) * X ^ 9
def CU_004_2_pim : Polynomial ℚ := C ((54958511679952 / 78598333 : ℚ)) + C ((109917023359904 / 78598333 : ℚ)) * X + C ((13403679626136 / 7145303 : ℚ)) * X ^ 2 + C ((155598880274368 / 78598333 : ℚ)) * X ^ 3 + C ((131789658114584 / 78598333 : ℚ)) * X ^ 4 + C ((83596866251416 / 78598333 : ℚ)) * X ^ 5 + C ((26320157108488 / 78598333 : ℚ)) * X ^ 6 + C ((-21872634754680 / 78598333 : ℚ)) * X ^ 7 + C ((-45681856914464 / 78598333 : ℚ)) * X ^ 8 + C ((-37523452527592 / 78598333 : ℚ)) * X ^ 9
theorem CU_004_2_pre_eq :
    CU_2_re_002 * Fplus_dW_re_002 - CU_2_im_002 * Fplus_dW_im_002 = CU_004_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_004_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_004_2_pim_eq :
    CU_2_re_002 * Fplus_dW_im_002 + CU_2_im_002 * Fplus_dW_re_002 = CU_004_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_004_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_004_2_mul :
    CU_2_c_002 * Fplus_dW_c_002 = ofLadj CU_004_2_pre CU_004_2_pim := by
  rw [CU_2_c_002_def, Fplus_dW_c_002_def, ofLadj_mul, CU_004_2_pre_eq, CU_004_2_pim_eq]

@[expose] public def CU_coeff_004 : Ki := CU_0_c_002 * Fplus_dU_c_002 + CU_1_c_002 * Fplus_dV_c_002 + CU_2_c_002 * Fplus_dW_c_002

theorem CU_coeff_004_sum :
    CU_coeff_004 = ofLadj (CU_004_0_pre + CU_004_1_pre + CU_004_2_pre) (CU_004_0_pim + CU_004_1_pim + CU_004_2_pim) := by
  simp only [CU_coeff_004, CU_004_0_mul, CU_004_1_mul, CU_004_2_mul]
  simpa [add_assoc] using ofLadj_add3 CU_004_0_pre CU_004_0_pim CU_004_1_pre CU_004_1_pim CU_004_2_pre CU_004_2_pim

def CU_004_qre : Polynomial ℚ := C ((-255567214645616 / 235794999 : ℚ)) + C ((-5698472041996688 / 235794999 : ℚ)) * X + C ((-2047682887711192 / 78598333 : ℚ)) * X ^ 2 + C ((-7742089845195496 / 235794999 : ℚ)) * X ^ 3 + C ((-3486645656384536 / 78598333 : ℚ)) * X ^ 4 + C ((-2203977214604584 / 78598333 : ℚ)) * X ^ 5 + C ((-5821391581166440 / 235794999 : ℚ)) * X ^ 6 + C ((-3496487878872608 / 235794999 : ℚ)) * X ^ 7 + C ((450608804685432 / 78598333 : ℚ)) * X ^ 8
def CU_004_qim : Polynomial ℚ := C ((1545545608514256 / 78598333 : ℚ)) + C ((1545545608514256 / 78598333 : ℚ)) * X + C ((2097277517211848 / 235794999 : ℚ)) * X ^ 2 + C ((2777686157443424 / 235794999 : ℚ)) * X ^ 3 + C ((-1652234717693080 / 235794999 : ℚ)) * X ^ 4 + C ((-4764584233229768 / 235794999 : ℚ)) * X ^ 5 + C ((-1364111030983528 / 78598333 : ℚ)) * X ^ 6 + C ((-6872793945744376 / 235794999 : ℚ)) * X ^ 7 + C ((-357143842603624 / 21435909 : ℚ)) * X ^ 8
theorem CU_coeff_004_poly_re :
    CU_004_0_pre + CU_004_1_pre + CU_004_2_pre = (0 : Polynomial ℚ) + Phi11 * CU_004_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_004_0_pre, CU_004_1_pre, CU_004_2_pre, CU_004_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_004_poly_im :
    CU_004_0_pim + CU_004_1_pim + CU_004_2_pim = (0 : Polynomial ℚ) + Phi11 * CU_004_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_004_0_pim, CU_004_1_pim, CU_004_2_pim, CU_004_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_004_eq :
    CU_coeff_004 = (0 : Ki) := by
  rw [CU_coeff_004_sum, CU_coeff_004_poly_re,
    CU_coeff_004_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
