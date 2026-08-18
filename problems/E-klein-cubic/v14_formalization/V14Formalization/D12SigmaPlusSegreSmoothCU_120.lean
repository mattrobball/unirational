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

def CU_120_0_pre : Polynomial ℚ := C ((892031552140 / 235794999 : ℚ)) + C ((-130788936989504 / 235794999 : ℚ)) * X + C ((-261585889634296 / 235794999 : ℚ)) * X ^ 2 + C ((-426074211971960 / 235794999 : ℚ)) * X ^ 3 + C ((-65492122787408 / 21435909 : ℚ)) * X ^ 4 + C ((-922423527974720 / 235794999 : ℚ)) * X ^ 5 + C ((-1112137649354528 / 235794999 : ℚ)) * X ^ 6 + C ((-1194897001744948 / 235794999 : ℚ)) * X ^ 7 + C ((-1112332559458808 / 235794999 : ℚ)) * X ^ 8 + C ((-1053159533710520 / 235794999 : ℚ)) * X ^ 9 + C ((-30546486067268 / 7145303 : ℚ)) * X ^ 10 + C ((-330677482305344 / 78598333 : ℚ)) * X ^ 11 + C ((-877245103230340 / 235794999 : ℚ)) * X ^ 12 + C ((-791573644076224 / 235794999 : ℚ)) * X ^ 13 + C ((-228752782495616 / 78598333 : ℚ)) * X ^ 14 + C ((-148748847502872 / 78598333 : ℚ)) * X ^ 15 + C ((-92190348391040 / 78598333 : ℚ)) * X ^ 16 + C ((-28952307931104 / 78598333 : ℚ)) * X ^ 17 + C ((9412369524948 / 78598333 : ℚ)) * X ^ 18
def CU_120_0_pim : Polynomial ℚ := C ((11276113904672 / 21435909 : ℚ)) + C ((22552227809344 / 21435909 : ℚ)) * X + C ((320600866698344 / 235794999 : ℚ)) * X ^ 2 + C ((146583725579332 / 78598333 : ℚ)) * X ^ 3 + C ((147508792108144 / 78598333 : ℚ)) * X ^ 4 + C ((324843450547664 / 235794999 : ℚ)) * X ^ 5 + C ((194667789636208 / 235794999 : ℚ)) * X ^ 6 + C ((-54790808946512 / 235794999 : ℚ)) * X ^ 7 + C ((-17309184454324 / 21435909 : ℚ)) * X ^ 8 + C ((-181870637663728 / 235794999 : ℚ)) * X ^ 9 + C ((-142769628270788 / 235794999 : ℚ)) * X ^ 10 + C ((-209453995733104 / 235794999 : ℚ)) * X ^ 11 + C ((-760711744340 / 649573 : ℚ)) * X ^ 12 + C ((-309563714598040 / 235794999 : ℚ)) * X ^ 13 + C ((-420183633303856 / 235794999 : ℚ)) * X ^ 14 + C ((-40710038357672 / 21435909 : ℚ)) * X ^ 15 + C ((-126783424160660 / 78598333 : ℚ)) * X ^ 16 + C ((-103331484421772 / 78598333 : ℚ)) * X ^ 17 + C ((-36919543668984 / 78598333 : ℚ)) * X ^ 18
theorem CU_120_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_110 - CU_0_im_010 * Fplus_dU_im_110 = CU_120_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_110, Fplus_dU_im_110, CU_120_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_120_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_110 + CU_0_im_010 * Fplus_dU_re_110 = CU_120_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_110, Fplus_dU_im_110, CU_120_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_120_0_mul :
    CU_0_c_010 * Fplus_dU_c_110 = ofLadj CU_120_0_pre CU_120_0_pim := by
  rw [CU_0_c_010, Fplus_dU_c_110, ofLadj_mul, CU_120_0_pre_eq, CU_120_0_pim_eq]

def CU_120_1_pre : Polynomial ℚ := C ((-6820832544 / 78598333 : ℚ)) + C ((-276534924821560 / 235794999 : ℚ)) * X + C ((-523488759196720 / 235794999 : ℚ)) * X ^ 2 + C ((-900818367390496 / 235794999 : ℚ)) * X ^ 3 + C ((-1470646860533644 / 235794999 : ℚ)) * X ^ 4 + C ((-1897934028248140 / 235794999 : ℚ)) * X ^ 5 + C ((-770988414243764 / 78598333 : ℚ)) * X ^ 6 + C ((-2648456513950648 / 235794999 : ℚ)) * X ^ 7 + C ((-2693001968382040 / 235794999 : ℚ)) * X ^ 8 + C ((-2786893966755496 / 235794999 : ℚ)) * X ^ 9 + C ((-86626142436216 / 7145303 : ℚ)) * X ^ 10 + C ((-2885525072602580 / 235794999 : ℚ)) * X ^ 11 + C ((-2582127775573568 / 235794999 : ℚ)) * X ^ 12 + C ((-754468402519592 / 78598333 : ℚ)) * X ^ 13 + C ((-597394533663848 / 78598333 : ℚ)) * X ^ 14 + C ((-1136060041718840 / 235794999 : ℚ)) * X ^ 15 + C ((-657315511393592 / 235794999 : ℚ)) * X ^ 16 + C ((-80761432303480 / 78598333 : ℚ)) * X ^ 17 + C ((41749611698164 / 235794999 : ℚ)) * X ^ 18
def CU_120_1_pim : Polynomial ℚ := C ((255382118071196 / 235794999 : ℚ)) + C ((510764236142392 / 235794999 : ℚ)) * X + C ((229875106940572 / 78598333 : ℚ)) * X ^ 2 + C ((968727672116168 / 235794999 : ℚ)) * X ^ 3 + C ((338081206454104 / 78598333 : ℚ)) * X ^ 4 + C ((300466283648352 / 78598333 : ℚ)) * X ^ 5 + C ((790682185110076 / 235794999 : ℚ)) * X ^ 6 + C ((471590501906668 / 235794999 : ℚ)) * X ^ 7 + C ((242450796706144 / 235794999 : ℚ)) * X ^ 8 + C ((228960015340564 / 235794999 : ℚ)) * X ^ 9 + C ((55637681976500 / 78598333 : ℚ)) * X ^ 10 + C ((-179642397721108 / 235794999 : ℚ)) * X ^ 11 + C ((-526197841371716 / 235794999 : ℚ)) * X ^ 12 + C ((-69736899587464 / 21435909 : ℚ)) * X ^ 13 + C ((-1059699028122136 / 235794999 : ℚ)) * X ^ 14 + C ((-1065855068743400 / 235794999 : ℚ)) * X ^ 15 + C ((-873209263997084 / 235794999 : ℚ)) * X ^ 16 + C ((-222464110452624 / 78598333 : ℚ)) * X ^ 17 + C ((-89499870608468 / 78598333 : ℚ)) * X ^ 18
theorem CU_120_1_pre_eq :
    CU_1_re_010 * Fplus_dV_re_110 - CU_1_im_010 * Fplus_dV_im_110 = CU_120_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_110, Fplus_dV_im_110, CU_120_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_120_1_pim_eq :
    CU_1_re_010 * Fplus_dV_im_110 + CU_1_im_010 * Fplus_dV_re_110 = CU_120_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_110, Fplus_dV_im_110, CU_120_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_120_1_mul :
    CU_1_c_010 * Fplus_dV_c_110 = ofLadj CU_120_1_pre CU_120_1_pim := by
  rw [CU_1_c_010, Fplus_dV_c_110, ofLadj_mul, CU_120_1_pre_eq, CU_120_1_pim_eq]

def CU_120_2_pre : Polynomial ℚ := C ((-20556623184596 / 235794999 : ℚ)) + C ((-271908948962960 / 235794999 : ℚ)) * X + C ((-553864774904032 / 235794999 : ℚ)) * X ^ 2 + C ((-911687232054596 / 235794999 : ℚ)) * X ^ 3 + C ((-452042124230812 / 78598333 : ℚ)) * X ^ 4 + C ((-537128176979660 / 78598333 : ℚ)) * X ^ 5 + C ((-605951379028048 / 78598333 : ℚ)) * X ^ 6 + C ((-1930637075247688 / 235794999 : ℚ)) * X ^ 7 + C ((-1838749569166480 / 235794999 : ℚ)) * X ^ 8 + C ((-601356831971088 / 78598333 : ℚ)) * X ^ 9 + C ((-1777446005039380 / 235794999 : ℚ)) * X ^ 10 + C ((-1746917320732852 / 235794999 : ℚ)) * X ^ 11 + C ((-1505537056076420 / 235794999 : ℚ)) * X ^ 12 + C ((-1250205721009232 / 235794999 : ℚ)) * X ^ 13 + C ((-927062337111884 / 235794999 : ℚ)) * X ^ 14 + C ((-15592843451616 / 7145303 : ℚ)) * X ^ 15 + C ((-278407779817160 / 235794999 : ℚ)) * X ^ 16 + C ((-71938173671996 / 235794999 : ℚ)) * X ^ 17 + C ((59946868651924 / 235794999 : ℚ)) * X ^ 18
def CU_120_2_pim : Polynomial ℚ := C ((16627632597076 / 21435909 : ℚ)) + C ((33255265194152 / 21435909 : ℚ)) * X + C ((435294462751952 / 235794999 : ℚ)) * X ^ 2 + C ((170617802379524 / 78598333 : ℚ)) * X ^ 3 + C ((383960841100732 / 235794999 : ℚ)) * X ^ 4 + C ((133161548292416 / 235794999 : ℚ)) * X ^ 5 + C ((-68585159244964 / 235794999 : ℚ)) * X ^ 6 + C ((-121835583239020 / 78598333 : ℚ)) * X ^ 7 + C ((-535327605083276 / 235794999 : ℚ)) * X ^ 8 + C ((-530377291227908 / 235794999 : ℚ)) * X ^ 9 + C ((-507450667698848 / 235794999 : ℚ)) * X ^ 10 + C ((-656568041921108 / 235794999 : ℚ)) * X ^ 11 + C ((-805685416143368 / 235794999 : ℚ)) * X ^ 12 + C ((-284081779410196 / 78598333 : ℚ)) * X ^ 13 + C ((-923853968761840 / 235794999 : ℚ)) * X ^ 14 + C ((-270149623869924 / 78598333 : ℚ)) * X ^ 15 + C ((-196402063279072 / 78598333 : ℚ)) * X ^ 16 + C ((-422698365916780 / 235794999 : ℚ)) * X ^ 17 + C ((-155333386480444 / 235794999 : ℚ)) * X ^ 18
theorem CU_120_2_pre_eq :
    CU_2_re_010 * Fplus_dW_re_110 - CU_2_im_010 * Fplus_dW_im_110 = CU_120_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_110, Fplus_dW_im_110, CU_120_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_120_2_pim_eq :
    CU_2_re_010 * Fplus_dW_im_110 + CU_2_im_010 * Fplus_dW_re_110 = CU_120_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_110, Fplus_dW_im_110, CU_120_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_120_2_mul :
    CU_2_c_010 * Fplus_dW_c_110 = ofLadj CU_120_2_pre CU_120_2_pim := by
  rw [CU_2_c_010, Fplus_dW_c_110, ofLadj_mul, CU_120_2_pre_eq, CU_120_2_pim_eq]

theorem CU_120_3_mul : CU_3_c_020 = ofLadj CU_3_re_020 CU_3_im_020 := rfl

@[expose] public def CU_coeff_120 : Ki := CU_0_c_010 * Fplus_dU_c_110 + CU_1_c_010 * Fplus_dV_c_110 + CU_2_c_010 * Fplus_dW_c_110 + CU_3_c_020

theorem CU_coeff_120_sum :
    CU_coeff_120 = ofLadj (CU_120_0_pre + CU_120_1_pre + CU_120_2_pre + CU_3_re_020) (CU_120_0_pim + CU_120_1_pim + CU_120_2_pim + CU_3_im_020) := by
  simp only [CU_coeff_120, CU_120_0_mul, CU_120_1_mul, CU_120_2_mul, CU_120_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_120_0_pre CU_120_0_pim CU_120_1_pre CU_120_1_pim CU_120_2_pre CU_120_2_pim CU_3_re_020 CU_3_im_020

def CU_120_qre : Polynomial ℚ := C ((-19667905402888 / 235794999 : ℚ)) + C ((-659564905371136 / 235794999 : ℚ)) * X + C ((-659725362236096 / 235794999 : ℚ)) * X ^ 2 + C ((-899680287053956 / 235794999 : ℚ)) * X ^ 3 + C ((-436211289153164 / 78598333 : ℚ)) * X ^ 4 + C ((-884576081746912 / 235794999 : ℚ)) * X ^ 5 + C ((-811214942008124 / 235794999 : ℚ)) * X ^ 6 + C ((-531012983300680 / 235794999 : ℚ)) * X ^ 7 + C ((129933588924932 / 235794999 : ℚ)) * X ^ 8
def CU_120_qim : Polynomial ℚ := C ((187452395111728 / 78598333 : ℚ)) + C ((187452395111728 / 78598333 : ℚ)) * X + C ((320893327580228 / 235794999 : ℚ)) * X ^ 2 + C ((158273893965700 / 78598333 : ℚ)) * X ^ 3 + C ((-26540755966756 / 78598333 : ℚ)) * X ^ 4 + C ((-481348635971284 / 235794999 : ℚ)) * X ^ 5 + C ((-442680575776312 / 235794999 : ℚ)) * X ^ 6 + C ((-288497840409056 / 78598333 : ℚ)) * X ^ 7 + C ((-534591629312800 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_120_poly_re :
    CU_120_0_pre + CU_120_1_pre + CU_120_2_pre + CU_3_re_020 = (0 : Polynomial ℚ) + Phi11 * CU_120_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_120_0_pre, CU_120_1_pre, CU_120_2_pre, CU_3_re_020, CU_120_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_120_poly_im :
    CU_120_0_pim + CU_120_1_pim + CU_120_2_pim + CU_3_im_020 = (0 : Polynomial ℚ) + Phi11 * CU_120_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_120_0_pim, CU_120_1_pim, CU_120_2_pim, CU_3_im_020, CU_120_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_120_eq :
    CU_coeff_120 = (0 : Ki) := by
  rw [CU_coeff_120_sum, CU_coeff_120_poly_re,
    CU_coeff_120_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
