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

def CU_020_0_pre : Polynomial ℚ := C ((-43069159064 / 235794999 : ℚ)) + C ((-3254371442110 / 235794999 : ℚ)) * X + C ((-6193828496386 / 235794999 : ℚ)) * X ^ 2 + C ((-3651022999719 / 78598333 : ℚ)) * X ^ 3 + C ((-17632416645332 / 235794999 : ℚ)) * X ^ 4 + C ((-7551223474171 / 78598333 : ℚ)) * X ^ 5 + C ((-27914345748139 / 235794999 : ℚ)) * X ^ 6 + C ((-31836188965975 / 235794999 : ℚ)) * X ^ 7 + C ((-10755101566571 / 78598333 : ℚ)) * X ^ 8 + C ((-33432030273007 / 235794999 : ℚ)) * X ^ 9 + C ((-3117151153811 / 21435909 : ℚ)) * X ^ 10 + C ((-34509286391230 / 235794999 : ℚ)) * X ^ 11 + C ((-10344763749937 / 78598333 : ℚ)) * X ^ 12 + C ((-825400053837 / 7145303 : ℚ)) * X ^ 13 + C ((-7104078566852 / 78598333 : ℚ)) * X ^ 14 + C ((-4521557078056 / 78598333 : ℚ)) * X ^ 15 + C ((-2660318695116 / 78598333 : ℚ)) * X ^ 16 + C ((-2720280759722 / 235794999 : ℚ)) * X ^ 17 + C ((639101086475 / 235794999 : ℚ)) * X ^ 18
def CU_020_0_pim : Polynomial ℚ := C ((997613447957 / 78598333 : ℚ)) + C ((1995226895914 / 78598333 : ℚ)) * X + C ((8277240989129 / 235794999 : ℚ)) * X ^ 2 + C ((3852298237445 / 78598333 : ℚ)) * X ^ 3 + C ((11857569046019 / 235794999 : ℚ)) * X ^ 4 + C ((10729373998105 / 235794999 : ℚ)) * X ^ 5 + C ((283011054804 / 7145303 : ℚ)) * X ^ 6 + C ((5273946242456 / 235794999 : ℚ)) * X ^ 7 + C ((2573029825127 / 235794999 : ℚ)) * X ^ 8 + C ((2401594342019 / 235794999 : ℚ)) * X ^ 9 + C ((48446124559 / 7145303 : ℚ)) * X ^ 10 + C ((-819015360216 / 78598333 : ℚ)) * X ^ 11 + C ((-2170938090581 / 78598333 : ℚ)) * X ^ 12 + C ((-9607246804702 / 235794999 : ℚ)) * X ^ 13 + C ((-13058336011016 / 235794999 : ℚ)) * X ^ 14 + C ((-4283317936724 / 78598333 : ℚ)) * X ^ 15 + C ((-3576866072191 / 78598333 : ℚ)) * X ^ 16 + C ((-8266552063618 / 235794999 : ℚ)) * X ^ 17 + C ((-3209972951857 / 235794999 : ℚ)) * X ^ 18
theorem CU_020_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_020 - CU_0_im_000 * Fplus_dU_im_020 = CU_020_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_020, Fplus_dU_im_020, CU_020_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_020_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_020 + CU_0_im_000 * Fplus_dU_re_020 = CU_020_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_020, Fplus_dU_im_020, CU_020_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_020_0_mul :
    CU_0_c_000 * Fplus_dU_c_020 = ofLadj CU_020_0_pre CU_020_0_pim := by
  rw [CU_0_c_000, Fplus_dU_c_020, ofLadj_mul, CU_020_0_pre_eq, CU_020_0_pim_eq]

def CU_020_1_pre : Polynomial ℚ := C ((-61983689268 / 7145303 : ℚ)) + C ((-6590440943144 / 78598333 : ℚ)) * X + C ((-11478536773430 / 78598333 : ℚ)) * X ^ 2 + C ((-18531080706234 / 78598333 : ℚ)) * X ^ 3 + C ((-2545232240457 / 7145303 : ℚ)) * X ^ 4 + C ((-31839564254017 / 78598333 : ℚ)) * X ^ 5 + C ((-36507912983615 / 78598333 : ℚ)) * X ^ 6 + C ((-41907552051864 / 78598333 : ℚ)) * X ^ 7 + C ((-42911788580601 / 78598333 : ℚ)) * X ^ 8 + C ((-46259155677716 / 78598333 : ℚ)) * X ^ 9 + C ((-48818740568245 / 78598333 : ℚ)) * X ^ 10 + C ((-49092590360192 / 78598333 : ℚ)) * X ^ 11 + C ((-42228299625101 / 78598333 : ℚ)) * X ^ 12 + C ((-34780618904286 / 78598333 : ℚ)) * X ^ 13 + C ((-24380707874367 / 78598333 : ℚ)) * X ^ 14 + C ((-11836217750200 / 78598333 : ℚ)) * X ^ 15 + C ((-6161464490682 / 78598333 : ℚ)) * X ^ 16 + C ((-1493115761084 / 78598333 : ℚ)) * X ^ 17 + C ((2073779656637 / 78598333 : ℚ)) * X ^ 18
def CU_020_1_pim : Polynomial ℚ := C ((3778115298491 / 78598333 : ℚ)) + C ((7556230596982 / 78598333 : ℚ)) * X + C ((8704516046549 / 78598333 : ℚ)) * X ^ 2 + C ((1025984831632 / 7145303 : ℚ)) * X ^ 3 + C ((8493604518090 / 78598333 : ℚ)) * X ^ 4 + C ((3821943046725 / 78598333 : ℚ)) * X ^ 5 + C ((2572124749453 / 78598333 : ℚ)) * X ^ 6 + C ((-2166606911872 / 78598333 : ℚ)) * X ^ 7 + C ((-5786305007314 / 78598333 : ℚ)) * X ^ 8 + C ((-6266729884174 / 78598333 : ℚ)) * X ^ 9 + C ((-8480723217299 / 78598333 : ℚ)) * X ^ 10 + C ((-15508267375132 / 78598333 : ℚ)) * X ^ 11 + C ((-22535811532965 / 78598333 : ℚ)) * X ^ 12 + C ((-25898090315657 / 78598333 : ℚ)) * X ^ 13 + C ((-2632712026720 / 7145303 : ℚ)) * X ^ 14 + C ((-24764441108421 / 78598333 : ℚ)) * X ^ 15 + C ((-17245839809070 / 78598333 : ℚ)) * X ^ 16 + C ((-12608532140390 / 78598333 : ℚ)) * X ^ 17 + C ((-5022860651079 / 78598333 : ℚ)) * X ^ 18
theorem CU_020_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_020 - CU_1_im_000 * Fplus_dV_im_020 = CU_020_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_020, Fplus_dV_im_020, CU_020_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_020_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_020 + CU_1_im_000 * Fplus_dV_re_020 = CU_020_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_020, Fplus_dV_im_020, CU_020_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_020_1_mul :
    CU_1_c_000 * Fplus_dV_c_020 = ofLadj CU_020_1_pre CU_020_1_pim := by
  rw [CU_1_c_000, Fplus_dV_c_020, ofLadj_mul, CU_020_1_pre_eq, CU_020_1_pim_eq]

def CU_020_2_pre : Polynomial ℚ := C ((-10637275996012 / 235794999 : ℚ)) + C ((-149300994117184 / 235794999 : ℚ)) * X + C ((-296154828448288 / 235794999 : ℚ)) * X ^ 2 + C ((-161565056711808 / 78598333 : ℚ)) * X ^ 3 + C ((-723205188959509 / 235794999 : ℚ)) * X ^ 4 + C ((-287215614401392 / 78598333 : ℚ)) * X ^ 5 + C ((-974144826323120 / 235794999 : ℚ)) * X ^ 6 + C ((-94747842547576 / 21435909 : ℚ)) * X ^ 7 + C ((-993404444086958 / 235794999 : ℚ)) * X ^ 8 + C ((-982155717850367 / 235794999 : ℚ)) * X ^ 9 + C ((-973601581484794 / 235794999 : ℚ)) * X ^ 10 + C ((-959816452781524 / 235794999 : ℚ)) * X ^ 11 + C ((-274766862455870 / 78598333 : ℚ)) * X ^ 12 + C ((-686000889402079 / 235794999 : ℚ)) * X ^ 13 + C ((-508709273951534 / 235794999 : ℚ)) * X ^ 14 + C ((-280528615492760 / 235794999 : ℚ)) * X ^ 15 + C ((-148168232043956 / 235794999 : ℚ)) * X ^ 16 + C ((-11890082975004 / 78598333 : ℚ)) * X ^ 17 + C ((3499314870097 / 21435909 : ℚ)) * X ^ 18
def CU_020_2_pim : Polynomial ℚ := C ((101636197303340 / 235794999 : ℚ)) + C ((203272394606680 / 235794999 : ℚ)) * X + C ((238098212735602 / 235794999 : ℚ)) * X ^ 2 + C ((95319087236798 / 78598333 : ℚ)) * X ^ 3 + C ((219932562944492 / 235794999 : ℚ)) * X ^ 4 + C ((84861844215914 / 235794999 : ℚ)) * X ^ 5 + C ((-24750750279557 / 235794999 : ℚ)) * X ^ 6 + C ((-188494399217396 / 235794999 : ℚ)) * X ^ 7 + C ((-94877183394967 / 78598333 : ℚ)) * X ^ 8 + C ((-283008763894837 / 235794999 : ℚ)) * X ^ 9 + C ((-91848191724942 / 78598333 : ℚ)) * X ^ 10 + C ((-366335702308156 / 235794999 : ℚ)) * X ^ 11 + C ((-457126829441486 / 235794999 : ℚ)) * X ^ 12 + C ((-484488458850397 / 235794999 : ℚ)) * X ^ 13 + C ((-530724721535125 / 235794999 : ℚ)) * X ^ 14 + C ((-156479805221890 / 78598333 : ℚ)) * X ^ 15 + C ((-114640775311893 / 78598333 : ℚ)) * X ^ 16 + C ((-245587778010310 / 235794999 : ℚ)) * X ^ 17 + C ((-91397758071058 / 235794999 : ℚ)) * X ^ 18
theorem CU_020_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_020 - CU_2_im_000 * Fplus_dW_im_020 = CU_020_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_020, Fplus_dW_im_020, CU_020_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_020_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_020 + CU_2_im_000 * Fplus_dW_re_020 = CU_020_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_020, Fplus_dW_im_020, CU_020_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_020_2_mul :
    CU_2_c_000 * Fplus_dW_c_020 = ofLadj CU_020_2_pre CU_020_2_pim := by
  rw [CU_2_c_000, Fplus_dW_c_020, ofLadj_mul, CU_020_2_pre_eq, CU_020_2_pim_eq]

def CU_020_3_pre : Polynomial ℚ := C ((-800 / 11 : ℚ)) + C ((2624 / 33 : ℚ)) * X ^ 2 + C ((2736 / 11 : ℚ)) * X ^ 3 + C ((4000 / 11 : ℚ)) * X ^ 4 + C ((4960 / 11 : ℚ)) * X ^ 5 + C ((4960 / 11 : ℚ)) * X ^ 6 + C ((4000 / 11 : ℚ)) * X ^ 7 + C ((2736 / 11 : ℚ)) * X ^ 8 + C ((2624 / 33 : ℚ)) * X ^ 9
def CU_020_3_pim : Polynomial ℚ := C ((-52120 / 363 : ℚ)) + C ((-104240 / 363 : ℚ)) * X + C ((-134008 / 363 : ℚ)) * X ^ 2 + C ((-49840 / 121 : ℚ)) * X ^ 3 + C ((-117424 / 363 : ℚ)) * X ^ 4 + C ((-28032 / 121 : ℚ)) * X ^ 5 + C ((-20144 / 363 : ℚ)) * X ^ 6 + C ((13184 / 363 : ℚ)) * X ^ 7 + C ((45280 / 363 : ℚ)) * X ^ 8 + C ((29768 / 363 : ℚ)) * X ^ 9
theorem CU_020_3_neg_re : -CU_3_re_020 = CU_020_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_020, CU_020_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_020_3_neg_im : -CU_3_im_020 = CU_020_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_020, CU_020_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_020_3_mul : -CU_3_c_020 = ofLadj CU_020_3_pre CU_020_3_pim := by
  rw [CU_3_c_020, ofLadj_neg, CU_020_3_neg_re, CU_020_3_neg_im]

@[expose] public def CU_coeff_020 : Ki := CU_0_c_000 * Fplus_dU_c_020 + CU_1_c_000 * Fplus_dV_c_020 + CU_2_c_000 * Fplus_dW_c_020 + (-CU_3_c_020)

theorem CU_coeff_020_sum :
    CU_coeff_020 = ofLadj (CU_020_0_pre + CU_020_1_pre + CU_020_2_pre + CU_020_3_pre) (CU_020_0_pim + CU_020_1_pim + CU_020_2_pim + CU_020_3_pim) := by
  simp only [CU_coeff_020, CU_020_0_mul, CU_020_1_mul, CU_020_2_mul, CU_020_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_020_0_pre CU_020_0_pim CU_020_1_pre CU_020_1_pim CU_020_2_pre CU_020_2_pim CU_020_3_pre CU_020_3_pim

def CU_020_qre : Polynomial ℚ := C ((-4247651876040 / 78598333 : ℚ)) + C ((-14507612069146 / 21435909 : ℚ)) * X + C ((-164438829601166 / 235794999 : ℚ)) * X ^ 2 + C ((-214417314616367 / 235794999 : ℚ)) * X ^ 3 + C ((-91187231099221 / 78598333 : ℚ)) * X ^ 4 + C ((-51656119458726 / 78598333 : ℚ)) * X ^ 5 + C ((-43921234877788 / 78598333 : ℚ)) * X ^ 6 + C ((-29407593531813 / 78598333 : ℚ)) * X ^ 7 + C ((45352903627453 / 235794999 : ℚ)) * X ^ 8
def CU_020_qim : Polynomial ℚ := C ((115929527797924 / 235794999 : ℚ)) + C ((115929527797924 / 235794999 : ℚ)) * X + C ((13514299429982 / 78598333 : ℚ)) * X ^ 2 + C ((5352052529621 / 21435909 : ℚ)) * X ^ 3 + C ((-24693287208932 / 78598333 : ℚ)) * X ^ 4 + C ((-50064083073881 / 78598333 : ℚ)) * X ^ 5 + C ((-114710517084364 / 235794999 : ℚ)) * X ^ 6 + C ((-60667871172982 / 78598333 : ℚ)) * X ^ 7 + C ((-109676312976152 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_020_poly_re :
    CU_020_0_pre + CU_020_1_pre + CU_020_2_pre + CU_020_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_020_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_020_0_pre, CU_020_1_pre, CU_020_2_pre, CU_020_3_pre, CU_020_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_020_poly_im :
    CU_020_0_pim + CU_020_1_pim + CU_020_2_pim + CU_020_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_020_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_020_0_pim, CU_020_1_pim, CU_020_2_pim, CU_020_3_pim, CU_020_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_020_eq :
    CU_coeff_020 = (0 : Ki) := by
  rw [CU_coeff_020_sum, CU_coeff_020_poly_re,
    CU_coeff_020_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
