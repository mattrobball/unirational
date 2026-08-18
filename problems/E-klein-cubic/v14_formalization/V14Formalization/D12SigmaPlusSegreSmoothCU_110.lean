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

def CU_110_0_pre : Polynomial ℚ := interpQ 235794999 [-16325357805, -2603497153688, -5226413969850, -8765248478966, -14604890097668, -18578433642113, -22681530064672, -24310485580084, -22516725566101, -21306336204583, -20377439099984, -20049451413842, -17773941946296, -16079922234733, -13751477087135, -9036795413213, -5699641670635, -1596545248076, 668800069203]
def CU_110_0_pim : Polynomial ℚ := interpQ 235794999 [2459359703939, 4918719407878, 6510347013222, 8888367362772, 8722696208570, 6542051428341, 3897857847982, -1388754692096, -4126979791433, -3957488293437, -3135604781480, -4438959160522, -5742313539564, -6512057632951, -8720586484505, -9063997851571, -7929798646179, -6469309543310, -2229142578069]
theorem CU_110_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_110 - CU_0_im_000 * Fplus_dU_im_110 = CU_110_0_pre := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_110_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_110_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_110 + CU_0_im_000 * Fplus_dU_re_110 = CU_110_0_pim := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_110_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_110_0_mul :
    CU_0_c_000 * Fplus_dU_c_110 = ofLadj CU_110_0_pre CU_110_0_pim := by
  rw [CU_0_c_000_def, Fplus_dU_c_110_def, ofLadj_mul, CU_110_0_pre_eq, CU_110_0_pim_eq]

def CU_110_1_pre : Polynomial ℚ := interpQ 235794999 [28839121307, 32952204715720, 62426961104389, 107444076463322, 175346879894912, 226302551168077, 275801262732028, 315808745502028, 321097392290373, 332311056614401, 340851194285251, 344034331359700, 307898989569531, 269884095510012, 213653315827051, 135465948510132, 78380065091411, 28881353527460, -4995917096984]
def CU_110_1_pim : Polynomial ℚ := interpQ 235794999 [-30423848142957, -60847696285914, -82215219620453, -115431531230970, -120854027297430, -107405314087035, -94197837341142, -56112364071668, -28789456138777, -27168630717051, -19768335169469, 21522588858936, 62813512887341, 91581331769462, 126418468801705, 127127989505506, 104175516035107, 79625116825028, 32035883295550]
theorem CU_110_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_110 - CU_1_im_000 * Fplus_dV_im_110 = CU_110_1_pre := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_110_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_110_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_110 + CU_1_im_000 * Fplus_dV_re_110 = CU_110_1_pim := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_110_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_110_1_mul :
    CU_1_c_000 * Fplus_dV_c_110 = ofLadj CU_110_1_pre CU_110_1_pim := by
  rw [CU_1_c_000_def, Fplus_dV_c_110_def, ofLadj_mul, CU_110_1_pre_eq, CU_110_1_pim_eq]

def CU_110_2_pre : Polynomial ℚ := interpQ 235794999 [7822322959616, 106643567226560, 216920408499904, 356052708937956, 530316415555190, 630411865966748, 710503772228022, 754832738552563, 719283872070978, 705671338109372, 695309902464233, 683643761648832, 588666335237673, 488750929609468, 363231163133022, 201464038891437, 108761443595722, 28669537334448, -23052284105936]
def CU_110_2_pim : Polynomial ℚ := interpQ 235794999 [-71835544022196, -143671088044392, -170203933781974, -200511051339506, -151239608337598, -52690448651820, 26011261358948, 141403570610975, 207870648761740, 205906532019790, 196891727486689, 255574440664308, 314257153841927, 331775195046408, 360118195861990, 316575146864773, 229580944821072, 164576035756024, 60738684146074]
theorem CU_110_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_110 - CU_2_im_000 * Fplus_dW_im_110 = CU_110_2_pre := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_110_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_110_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_110 + CU_2_im_000 * Fplus_dW_re_110 = CU_110_2_pim := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_110_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_110_2_mul :
    CU_2_c_000 * Fplus_dW_c_110 = ofLadj CU_110_2_pre CU_110_2_pim := by
  rw [CU_2_c_000_def, Fplus_dW_c_110_def, ofLadj_mul, CU_110_2_pre_eq, CU_110_2_pim_eq]

def CU_110_3_pre : Polynomial ℚ := interpQ 235794999 [320179331692, 0, -892400869690, -2080881145750, -3167939691290, -3794192859710, -3794192859710, -3167939691290, -2080881145750, -892400869690]
def CU_110_3_pim : Polynomial ℚ := interpQ 235794999 [1129749634232, 2259499268464, 3052124742026, 3225924564254, 2719588443490, 1714836636254, 544662632210, -460089175026, -966425295790, -792625473562]
theorem CU_110_3_neg_re : -CU_3_re_110 = CU_110_3_pre := by
  simp only [CU_3_re_110_def, CU_110_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_110_3_neg_im : -CU_3_im_110 = CU_110_3_pim := by
  simp only [CU_3_im_110_def, CU_110_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_110_3_mul : -CU_3_c_110 = ofLadj CU_110_3_pre CU_110_3_pim := by
  rw [CU_3_c_110_def, ofLadj_neg, CU_110_3_neg_re, CU_110_3_neg_im]

@[expose] public def CU_coeff_110 : Ki := CU_0_c_000 * Fplus_dU_c_110 + CU_1_c_000 * Fplus_dV_c_110 + CU_2_c_000 * Fplus_dW_c_110 + (-CU_3_c_110)

theorem CU_coeff_110_sum :
    CU_coeff_110 = ofLadj (CU_110_0_pre + CU_110_1_pre + CU_110_2_pre + CU_110_3_pre) (CU_110_0_pim + CU_110_1_pim + CU_110_2_pim + CU_110_3_pim) := by
  simp only [CU_coeff_110, CU_110_0_mul, CU_110_1_mul, CU_110_2_mul, CU_110_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_110_0_pre CU_110_0_pim CU_110_1_pre CU_110_1_pim CU_110_2_pre CU_110_2_pim CU_110_3_pre CU_110_3_pim

def CU_110_qre : Polynomial ℚ := interpQ 235794999 [8155016054810, 128837258733782, 136236279976161, 179422101011809, 235239809884582, 146451324971858, 125487521402666, 83333746747549, -27379401133717]
def CU_110_qim : Polynomial ℚ := interpQ 235794999 [-98670282826982, -98670282826982, -45516115993215, -60971608996271, 43176939660482, 108812476308708, 88094819172258, 147186418174187, 90545424863555]
theorem CU_coeff_110_poly_re :
    CU_110_0_pre + CU_110_1_pre + CU_110_2_pre + CU_110_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_110_qre := by
  rw [phi11_interpQ]
  simp only [CU_110_0_pre, CU_110_1_pre, CU_110_2_pre, CU_110_3_pre, CU_110_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_110_poly_im :
    CU_110_0_pim + CU_110_1_pim + CU_110_2_pim + CU_110_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_110_qim := by
  rw [phi11_interpQ]
  simp only [CU_110_0_pim, CU_110_1_pim, CU_110_2_pim, CU_110_3_pim, CU_110_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_110_eq :
    CU_coeff_110 = (0 : Ki) := by
  rw [CU_coeff_110_sum, CU_coeff_110_poly_re,
    CU_coeff_110_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
