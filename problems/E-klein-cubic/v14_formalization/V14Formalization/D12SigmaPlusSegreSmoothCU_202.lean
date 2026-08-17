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

def CU_202_0_pre : Polynomial ℚ := C ((84518593133028 / 78598333 : ℚ)) + C ((-74440551524964 / 78598333 : ℚ)) * X ^ 2 + C ((-213453132707816 / 78598333 : ℚ)) * X ^ 3 + C ((-656586477308092 / 78598333 : ℚ)) * X ^ 4 + C ((-1102433665994156 / 78598333 : ℚ)) * X ^ 5 + C ((-1561347764640028 / 78598333 : ℚ)) * X ^ 6 + C ((-1934249052137960 / 78598333 : ℚ)) * X ^ 7 + C ((-2075281277928720 / 78598333 : ℚ)) * X ^ 8 + C ((-2135537154291428 / 78598333 : ℚ)) * X ^ 9 + C ((-2181541492669424 / 78598333 : ℚ)) * X ^ 10 + C ((-2283206278100316 / 78598333 : ℚ)) * X ^ 11 + C ((-2181541492669424 / 78598333 : ℚ)) * X ^ 12 + C ((-2061096602766464 / 78598333 : ℚ)) * X ^ 13 + C ((-1861828145220904 / 78598333 : ℚ)) * X ^ 14 + C ((-1363320738109356 / 78598333 : ℚ)) * X ^ 15 + C ((-884566515823440 / 78598333 : ℚ)) * X ^ 16 + C ((-425652417177568 / 78598333 : ℚ)) * X ^ 17 + C ((-85658163279488 / 78598333 : ℚ)) * X ^ 18
def CU_202_0_pim : Polynomial ℚ := C ((287891788981092 / 78598333 : ℚ)) + C ((575783577962184 / 78598333 : ℚ)) * X + C ((936064502948132 / 78598333 : ℚ)) * X ^ 2 + C ((1424708232469092 / 78598333 : ℚ)) * X ^ 3 + C ((156974622671880 / 7145303 : ℚ)) * X ^ 4 + C ((1871140168540136 / 78598333 : ℚ)) * X ^ 5 + C ((1909588090143900 / 78598333 : ℚ)) * X ^ 6 + C ((1631741777008468 / 78598333 : ℚ)) * X ^ 7 + C ((1450430906761688 / 78598333 : ℚ)) * X ^ 8 + C ((1441767208944420 / 78598333 : ℚ)) * X ^ 9 + C ((1401900264631844 / 78598333 : ℚ)) * X ^ 10 + C ((95963929660364 / 7145303 : ℚ)) * X ^ 11 + C ((709306187896164 / 78598333 : ℚ)) * X ^ 12 + C ((309158318597640 / 78598333 : ℚ)) * X ^ 13 + C ((-188149108740588 / 78598333 : ℚ)) * X ^ 14 + C ((-464871905900132 / 78598333 : ℚ)) * X ^ 15 + C ((-558079516298092 / 78598333 : ℚ)) * X ^ 16 + C ((-535658711895752 / 78598333 : ℚ)) * X ^ 17 + C ((-206600690008824 / 78598333 : ℚ)) * X ^ 18
theorem CU_202_0_pre_eq :
    CU_0_re_002 * Fplus_dU_re_200 - CU_0_im_002 * Fplus_dU_im_200 = CU_202_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_200, Fplus_dU_im_200, CU_202_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_202_0_pim_eq :
    CU_0_re_002 * Fplus_dU_im_200 + CU_0_im_002 * Fplus_dU_re_200 = CU_202_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_200, Fplus_dU_im_200, CU_202_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_202_0_mul :
    CU_0_c_002 * Fplus_dU_c_200 = ofLadj CU_202_0_pre CU_202_0_pim := by
  rw [CU_0_c_002, Fplus_dU_c_200, ofLadj_mul, CU_202_0_pre_eq, CU_202_0_pim_eq]

def CU_202_1_pre : Polynomial ℚ := C ((4017041316004 / 235794999 : ℚ)) + C ((-193353065220640 / 78598333 : ℚ)) * X + C ((-1159937578054204 / 235794999 : ℚ)) * X ^ 2 + C ((-630111820630300 / 78598333 : ℚ)) * X ^ 3 + C ((-1065255284698940 / 78598333 : ℚ)) * X ^ 4 + C ((-4091220856096160 / 235794999 : ℚ)) * X ^ 5 + C ((-4933911062939668 / 235794999 : ℚ)) * X ^ 6 + C ((-1766908596039996 / 78598333 : ℚ)) * X ^ 7 + C ((-4933970410082332 / 235794999 : ℚ)) * X ^ 8 + C ((-1557184481606328 / 78598333 : ℚ)) * X ^ 9 + C ((-4471184862324956 / 235794999 : ℚ)) * X ^ 10 + C ((-1466838315768392 / 78598333 : ℚ)) * X ^ 11 + C ((-3891125666663036 / 235794999 : ℚ)) * X ^ 12 + C ((-3511615866764780 / 235794999 : ℚ)) * X ^ 13 + C ((-3043634948191432 / 235794999 : ℚ)) * X ^ 14 + C ((-659789523477328 / 78598333 : ℚ)) * X ^ 15 + C ((-409081934250580 / 78598333 : ℚ)) * X ^ 16 + C ((-384555595908232 / 235794999 : ℚ)) * X ^ 17 + C ((41863787863728 / 78598333 : ℚ)) * X ^ 18
def CU_202_1_pim : Polynomial ℚ := C ((550132321984604 / 235794999 : ℚ)) + C ((1100264643969208 / 235794999 : ℚ)) * X + C ((1422231757077400 / 235794999 : ℚ)) * X ^ 2 + C ((1951004422529260 / 235794999 : ℚ)) * X ^ 3 + C ((1962366768407152 / 235794999 : ℚ)) * X ^ 4 + C ((1441119967411864 / 235794999 : ℚ)) * X ^ 5 + C ((863752422900256 / 235794999 : ℚ)) * X ^ 6 + C ((-81286563560888 / 78598333 : ℚ)) * X ^ 7 + C ((-845101764777904 / 235794999 : ℚ)) * X ^ 8 + C ((-807374634255872 / 235794999 : ℚ)) * X ^ 9 + C ((-633755767428380 / 235794999 : ℚ)) * X ^ 10 + C ((-929509243808216 / 235794999 : ℚ)) * X ^ 11 + C ((-1225262720188052 / 235794999 : ℚ)) * X ^ 12 + C ((-124873724224432 / 21435909 : ℚ)) * X ^ 13 + C ((-621552167132860 / 78598333 : ℚ)) * X ^ 14 + C ((-1986149066810140 / 235794999 : ℚ)) * X ^ 15 + C ((-1687940155651448 / 235794999 : ℚ)) * X ^ 16 + C ((-458562026102632 / 78598333 : ℚ)) * X ^ 17 + C ((-163703951520524 / 78598333 : ℚ)) * X ^ 18
theorem CU_202_1_pre_eq :
    CU_1_re_002 * Fplus_dV_re_200 - CU_1_im_002 * Fplus_dV_im_200 = CU_202_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_200, Fplus_dV_im_200, CU_202_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_202_1_pim_eq :
    CU_1_re_002 * Fplus_dV_im_200 + CU_1_im_002 * Fplus_dV_re_200 = CU_202_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_200, Fplus_dV_im_200, CU_202_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_202_1_mul :
    CU_1_c_002 * Fplus_dV_c_200 = ofLadj CU_202_1_pre CU_202_1_pim := by
  rw [CU_1_c_002, Fplus_dV_c_200, ofLadj_mul, CU_202_1_pre_eq, CU_202_1_pim_eq]

def CU_202_2_pre : Polynomial ℚ := C ((123039289125952 / 235794999 : ℚ)) + C ((879336186879232 / 235794999 : ℚ)) * X + C ((552576584663472 / 78598333 : ℚ)) * X ^ 2 + C ((237036905940808 / 21435909 : ℚ)) * X ^ 3 + C ((1237303756029912 / 78598333 : ℚ)) * X ^ 4 + C ((4254652139425268 / 235794999 : ℚ)) * X ^ 5 + C ((4658110018174960 / 235794999 : ℚ)) * X ^ 6 + C ((1615061399752912 / 78598333 : ℚ)) * X ^ 7 + C ((4488230295927176 / 235794999 : ℚ)) * X ^ 8 + C ((4420195513845488 / 235794999 : ℚ)) * X ^ 9 + C ((4368235556208760 / 235794999 : ℚ)) * X ^ 10 + C ((1408607484904360 / 78598333 : ℚ)) * X ^ 11 + C ((9611293028456 / 649573 : ℚ)) * X ^ 12 + C ((2762465759855072 / 235794999 : ℚ)) * X ^ 13 + C ((626941443526096 / 78598333 : ℚ)) * X ^ 14 + C ((279616321409120 / 78598333 : ℚ)) * X ^ 15 + C ((333283671846776 / 235794999 : ℚ)) * X ^ 16 + C ((-23391402300972 / 78598333 : ℚ)) * X ^ 17 + C ((-98141322313880 / 78598333 : ℚ)) * X ^ 18
def CU_202_2_pim : Polynomial ℚ := C ((-131426969491872 / 78598333 : ℚ)) + C ((-262853938983744 / 78598333 : ℚ)) * X + C ((-68210953107200 / 21435909 : ℚ)) * X ^ 2 + C ((-249317196206976 / 78598333 : ℚ)) * X ^ 3 + C ((-6158998909752 / 7145303 : ℚ)) * X ^ 4 + C ((640096385428832 / 235794999 : ℚ)) * X ^ 5 + C ((1286168158424008 / 235794999 : ℚ)) * X ^ 6 + C ((2109372013987204 / 235794999 : ℚ)) * X ^ 7 + C ((2565026675176388 / 235794999 : ℚ)) * X ^ 8 + C ((2555248089256520 / 235794999 : ℚ)) * X ^ 9 + C ((2510238035355260 / 235794999 : ℚ)) * X ^ 10 + C ((2838552779804000 / 235794999 : ℚ)) * X ^ 11 + C ((287897047659340 / 21435909 : ℚ)) * X ^ 12 + C ((1027872045859816 / 78598333 : ℚ)) * X ^ 13 + C ((3071468656101308 / 235794999 : ℚ)) * X ^ 14 + C ((2555311287903596 / 235794999 : ℚ)) * X ^ 15 + C ((1769798703062216 / 235794999 : ℚ)) * X ^ 16 + C ((1192480495741712 / 235794999 : ℚ)) * X ^ 17 + C ((427107404787784 / 235794999 : ℚ)) * X ^ 18
theorem CU_202_2_pre_eq :
    CU_2_re_002 * Fplus_dW_re_200 - CU_2_im_002 * Fplus_dW_im_200 = CU_202_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_200, Fplus_dW_im_200, CU_202_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_202_2_pim_eq :
    CU_2_re_002 * Fplus_dW_im_200 + CU_2_im_002 * Fplus_dW_re_200 = CU_202_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_200, Fplus_dW_im_200, CU_202_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_202_2_mul :
    CU_2_c_002 * Fplus_dW_c_200 = ofLadj CU_202_2_pre CU_202_2_pim := by
  rw [CU_2_c_002, Fplus_dW_c_200, ofLadj_mul, CU_202_2_pre_eq, CU_202_2_pim_eq]

theorem CU_202_3_mul : CU_3_c_102 = ofLadj CU_3_re_102 CU_3_im_102 := rfl

@[expose] public def CU_coeff_202 : Ki := CU_0_c_002 * Fplus_dU_c_200 + CU_1_c_002 * Fplus_dV_c_200 + CU_2_c_002 * Fplus_dW_c_200 + CU_3_c_102

theorem CU_coeff_202_sum :
    CU_coeff_202 = ofLadj (CU_202_0_pre + CU_202_1_pre + CU_202_2_pre + CU_3_re_102) (CU_202_0_pim + CU_202_1_pim + CU_202_2_pim + CU_3_im_102) := by
  simp only [CU_coeff_202, CU_202_0_mul, CU_202_1_mul, CU_202_2_mul, CU_202_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_202_0_pre CU_202_0_pim CU_202_1_pre CU_202_1_pim CU_202_2_pre CU_202_2_pim CU_3_re_102 CU_3_im_102

def CU_202_qre : Polynomial ℚ := C ((34248867524416 / 21435909 : ℚ)) + C ((-77460551551264 / 235794999 : ℚ)) * X + C ((-1310078193880 / 21435909 : ℚ)) * X ^ 2 + C ((-184144861933244 / 235794999 : ℚ)) * X ^ 3 + C ((-1517813232743164 / 235794999 : ℚ)) * X ^ 4 + C ((-1682820142157408 / 235794999 : ℚ)) * X ^ 5 + C ((-605324874677144 / 78598333 : ℚ)) * X ^ 6 + C ((-1305879961154932 / 235794999 : ℚ)) * X ^ 7 + C ((-141935697729640 / 78598333 : ℚ)) * X ^ 8
def CU_202_qim : Polynomial ℚ := C ((335443282344872 / 78598333 : ℚ)) + C ((335443282344872 / 78598333 : ℚ)) * X + C ((1432043240849564 / 235794999 : ℚ)) * X ^ 2 + C ((1995115298422652 / 235794999 : ℚ)) * X ^ 3 + C ((1467818325087904 / 235794999 : ℚ)) * X ^ 4 + C ((766926504876568 / 235794999 : ℚ)) * X ^ 5 + C ((17981974251812 / 21435909 : ℚ)) * X ^ 6 + C ((-1106375198453180 / 235794999 : ℚ)) * X ^ 7 + C ((-683806519800260 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_202_poly_re :
    CU_202_0_pre + CU_202_1_pre + CU_202_2_pre + CU_3_re_102 = (0 : Polynomial ℚ) + Phi11 * CU_202_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_202_0_pre, CU_202_1_pre, CU_202_2_pre, CU_3_re_102, CU_202_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_202_poly_im :
    CU_202_0_pim + CU_202_1_pim + CU_202_2_pim + CU_3_im_102 = (0 : Polynomial ℚ) + Phi11 * CU_202_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_202_0_pim, CU_202_1_pim, CU_202_2_pim, CU_3_im_102, CU_202_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CU_coeff_202_eq :
    CU_coeff_202 = (0 : Ki) := by
  rw [CU_coeff_202_sum, CU_coeff_202_poly_re,
    CU_coeff_202_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
