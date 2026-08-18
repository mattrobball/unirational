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

def CU_030_0_pre : Polynomial ℚ := C ((-84577195522 / 235794999 : ℚ)) + C ((-163486171236880 / 235794999 : ℚ)) * X + C ((-103196211470630 / 78598333 : ℚ)) * X ^ 2 + C ((-532846392433106 / 235794999 : ℚ)) * X ^ 3 + C ((-869710062949954 / 235794999 : ℚ)) * X ^ 4 + C ((-374134415558404 / 78598333 : ℚ)) * X ^ 5 + C ((-455980285886186 / 78598333 : ℚ)) * X ^ 6 + C ((-522112086887608 / 78598333 : ℚ)) * X ^ 7 + C ((-1592602595864578 / 235794999 : ℚ)) * X ^ 8 + C ((-549393238480536 / 78598333 : ℚ)) * X ^ 9 + C ((-1690583267652674 / 235794999 : ℚ)) * X ^ 10 + C ((-1706399177713616 / 235794999 : ℚ)) * X ^ 11 + C ((-1527097096415794 / 235794999 : ℚ)) * X ^ 12 + C ((-446197027009906 / 78598333 : ℚ)) * X ^ 13 + C ((-1059756203431472 / 235794999 : ℚ)) * X ^ 14 + C ((-671862063175682 / 235794999 : ℚ)) * X ^ 15 + C ((-129587011187362 / 78598333 : ℚ)) * X ^ 16 + C ((-47741140859580 / 78598333 : ℚ)) * X ^ 17 + C ((8254711512396 / 78598333 : ℚ)) * X ^ 18
def CU_030_0_pim : Polynomial ℚ := C ((150959411908318 / 235794999 : ℚ)) + C ((301918823816636 / 235794999 : ℚ)) * X + C ((407826098808358 / 235794999 : ℚ)) * X ^ 2 + C ((572731986120614 / 235794999 : ℚ)) * X ^ 3 + C ((54507859714834 / 21435909 : ℚ)) * X ^ 4 + C ((16148896287336 / 7145303 : ℚ)) * X ^ 5 + C ((467415947405866 / 235794999 : ℚ)) * X ^ 6 + C ((92857949970336 / 78598333 : ℚ)) * X ^ 7 + C ((13006997810498 / 21435909 : ℚ)) * X ^ 8 + C ((135068252485780 / 235794999 : ℚ)) * X ^ 9 + C ((98357053626214 / 235794999 : ℚ)) * X ^ 10 + C ((-35501877330448 / 78598333 : ℚ)) * X ^ 11 + C ((-311368317608902 / 235794999 : ℚ)) * X ^ 12 + C ((-151328930486730 / 78598333 : ℚ)) * X ^ 13 + C ((-626901402202144 / 235794999 : ℚ)) * X ^ 14 + C ((-210141905240174 / 78598333 : ℚ)) * X ^ 15 + C ((-516578269968854 / 235794999 : ℚ)) * X ^ 16 + C ((-131614565028384 / 78598333 : ℚ)) * X ^ 17 + C ((-52942343739904 / 78598333 : ℚ)) * X ^ 18
theorem CU_030_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_020 - CU_0_im_010 * Fplus_dU_im_020 = CU_030_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_020, Fplus_dU_im_020, CU_030_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_030_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_020 + CU_0_im_010 * Fplus_dU_re_020 = CU_030_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_020, Fplus_dU_im_020, CU_030_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_030_0_mul :
    CU_0_c_010 * Fplus_dU_c_020 = ofLadj CU_030_0_pre CU_030_0_pim := by
  rw [CU_0_c_010, Fplus_dU_c_020, ofLadj_mul, CU_030_0_pre_eq, CU_030_0_pim_eq]

def CU_030_1_pre : Polynomial ℚ := C ((5695773451930 / 78598333 : ℚ)) + C ((55306984964312 / 78598333 : ℚ)) * X + C ((96276068546418 / 78598333 : ℚ)) * X ^ 2 + C ((155388767396068 / 78598333 : ℚ)) * X ^ 3 + C ((234851581689408 / 78598333 : ℚ)) * X ^ 4 + C ((267033832008404 / 78598333 : ℚ)) * X ^ 5 + C ((306183373026360 / 78598333 : ℚ)) * X ^ 6 + C ((351500959074982 / 78598333 : ℚ)) * X ^ 7 + C ((359942199493838 / 78598333 : ℚ)) * X ^ 8 + C ((387978077555526 / 78598333 : ℚ)) * X ^ 9 + C ((409467398819562 / 78598333 : ℚ)) * X ^ 10 + C ((411819570749280 / 78598333 : ℚ)) * X ^ 11 + C ((354160413855250 / 78598333 : ℚ)) * X ^ 12 + C ((291702009009108 / 78598333 : ℚ)) * X ^ 13 + C ((204553432097770 / 78598333 : ℚ)) * X ^ 14 + C ((99288500857346 / 78598333 : ℚ)) * X ^ 15 + C ((51693072648540 / 78598333 : ℚ)) * X ^ 16 + C ((12543531630584 / 78598333 : ℚ)) * X ^ 17 + C ((-17360876528228 / 78598333 : ℚ)) * X ^ 18
def CU_030_1_pim : Polynomial ℚ := C ((-31718978876730 / 78598333 : ℚ)) + C ((-63437957753460 / 78598333 : ℚ)) * X + C ((-73010610368750 / 78598333 : ℚ)) * X ^ 2 + C ((-94742296363244 / 78598333 : ℚ)) * X ^ 3 + C ((-71318161857116 / 78598333 : ℚ)) * X ^ 4 + C ((-32115443563404 / 78598333 : ℚ)) * X ^ 5 + C ((-21686029227072 / 78598333 : ℚ)) * X ^ 6 + C ((18031762508806 / 78598333 : ℚ)) * X ^ 7 + C ((48406910972642 / 78598333 : ℚ)) * X ^ 8 + C ((52418586970602 / 78598333 : ℚ)) * X ^ 9 + C ((70951094019846 / 78598333 : ℚ)) * X ^ 10 + C ((129950353983552 / 78598333 : ℚ)) * X ^ 11 + C ((188949613947258 / 78598333 : ℚ)) * X ^ 12 + C ((217054773611792 / 78598333 : ℚ)) * X ^ 13 + C ((242798135604246 / 78598333 : ℚ)) * X ^ 14 + C ((207646669443698 / 78598333 : ℚ)) * X ^ 15 + C ((144573397228264 / 78598333 : ℚ)) * X ^ 16 + C ((105690825775856 / 78598333 : ℚ)) * X ^ 17 + C ((42102480118256 / 78598333 : ℚ)) * X ^ 18
theorem CU_030_1_pre_eq :
    CU_1_re_010 * Fplus_dV_re_020 - CU_1_im_010 * Fplus_dV_im_020 = CU_030_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_020, Fplus_dV_im_020, CU_030_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_030_1_pim_eq :
    CU_1_re_010 * Fplus_dV_im_020 + CU_1_im_010 * Fplus_dV_re_020 = CU_030_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_020, Fplus_dV_im_020, CU_030_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_030_1_mul :
    CU_1_c_010 * Fplus_dV_c_020 = ofLadj CU_030_1_pre CU_030_1_pim := by
  rw [CU_1_c_010, Fplus_dV_c_020, ofLadj_mul, CU_030_1_pre_eq, CU_030_1_pim_eq]

def CU_030_2_pre : Polynomial ℚ := C ((27988928890832 / 235794999 : ℚ)) + C ((380672528548144 / 235794999 : ℚ)) * X + C ((252065830257118 / 78598333 : ℚ)) * X ^ 2 + C ((1241282050912646 / 235794999 : ℚ)) * X ^ 3 + C ((1849359308403344 / 235794999 : ℚ)) * X ^ 4 + C ((734126007981698 / 78598333 : ℚ)) * X ^ 5 + C ((830837826936720 / 78598333 : ℚ)) * X ^ 6 + C ((888586590177992 / 78598333 : ℚ)) * X ^ 7 + C ((846476148188036 / 78598333 : ℚ)) * X ^ 8 + C ((2510897929956074 / 235794999 : ℚ)) * X ^ 9 + C ((2488833518375032 / 235794999 : ℚ)) * X ^ 10 + C ((817533746865240 / 78598333 : ℚ)) * X ^ 11 + C ((702720329942296 / 78598333 : ℚ)) * X ^ 12 + C ((1754700439184720 / 235794999 : ℚ)) * X ^ 13 + C ((1298146393651462 / 235794999 : ℚ)) * X ^ 14 + C ((21710455068578 / 7145303 : ℚ)) * X ^ 15 + C ((379257989502416 / 235794999 : ℚ)) * X ^ 16 + C ((89122532637350 / 235794999 : ℚ)) * X ^ 17 + C ((-99955444867558 / 235794999 : ℚ)) * X ^ 18
def CU_030_2_pim : Polynomial ℚ := C ((-86261543828200 / 78598333 : ℚ)) + C ((-172523087656400 / 78598333 : ℚ)) * X + C ((-203012613421094 / 78598333 : ℚ)) * X ^ 2 + C ((-729968480359114 / 235794999 : ℚ)) * X ^ 3 + C ((-186163538917052 / 78598333 : ℚ)) * X ^ 4 + C ((-214951448475902 / 235794999 : ℚ)) * X ^ 5 + C ((65995129922296 / 235794999 : ℚ)) * X ^ 6 + C ((487475013761228 / 235794999 : ℚ)) * X ^ 7 + C ((733013539526024 / 235794999 : ℚ)) * X ^ 8 + C ((728987234961842 / 235794999 : ℚ)) * X ^ 9 + C ((710100912673676 / 235794999 : ℚ)) * X ^ 10 + C ((940947974606588 / 235794999 : ℚ)) * X ^ 11 + C ((1171795036539500 / 235794999 : ℚ)) * X ^ 12 + C ((1244377291545416 / 235794999 : ℚ)) * X ^ 13 + C ((453760542359022 / 78598333 : ℚ)) * X ^ 14 + C ((1201655601208186 / 235794999 : ℚ)) * X ^ 15 + C ((882553528327516 / 235794999 : ℚ)) * X ^ 16 + C ((630729476470066 / 235794999 : ℚ)) * X ^ 17 + C ((233686688025718 / 235794999 : ℚ)) * X ^ 18
theorem CU_030_2_pre_eq :
    CU_2_re_010 * Fplus_dW_re_020 - CU_2_im_010 * Fplus_dW_im_020 = CU_030_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_020, Fplus_dW_im_020, CU_030_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_030_2_pim_eq :
    CU_2_re_010 * Fplus_dW_im_020 + CU_2_im_010 * Fplus_dW_re_020 = CU_030_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_020, Fplus_dW_im_020, CU_030_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_030_2_mul :
    CU_2_c_010 * Fplus_dW_c_020 = ofLadj CU_030_2_pre CU_030_2_pim := by
  rw [CU_2_c_010, Fplus_dW_c_020, ofLadj_mul, CU_030_2_pre_eq, CU_030_2_pim_eq]

@[expose] public def CU_coeff_030 : Ki := CU_0_c_010 * Fplus_dU_c_020 + CU_1_c_010 * Fplus_dV_c_020 + CU_2_c_010 * Fplus_dW_c_020

theorem CU_coeff_030_sum :
    CU_coeff_030 = ofLadj (CU_030_0_pre + CU_030_1_pre + CU_030_2_pre) (CU_030_0_pim + CU_030_1_pim + CU_030_2_pim) := by
  simp only [CU_coeff_030, CU_030_0_mul, CU_030_1_mul, CU_030_2_mul]
  simpa [add_assoc] using ofLadj_add3 CU_030_0_pre CU_030_0_pim CU_030_1_pre CU_030_1_pim CU_030_2_pre CU_030_2_pim

def CU_030_qre : Polynomial ℚ := C ((44991672051100 / 235794999 : ℚ)) + C ((338115640153100 / 235794999 : ℚ)) * X + C ((117443249931506 / 78598333 : ℚ)) * X ^ 2 + C ((146388299556342 / 78598333 : ℚ)) * X ^ 3 + C ((509602029853870 / 235794999 : ℚ)) * X ^ 4 + C ((196872282773480 / 235794999 : ℚ)) * X ^ 5 + C ((54015489645196 / 78598333 : ℚ)) * X ^ 6 + C ((36934548288472 / 78598333 : ℚ)) * X ^ 7 + C ((-127273939915054 / 235794999 : ℚ)) * X ^ 8
def CU_030_qim : Polynomial ℚ := C ((-202982156206472 / 235794999 : ℚ)) + C ((-202982156206472 / 235794999 : ℚ)) * X + C ((-1298114558930 / 21435909 : ℚ)) * X ^ 2 + C ((-7073270255686 / 78598333 : ℚ)) * X ^ 3 + C ((268604737868902 / 235794999 : ℚ)) * X ^ 4 + C ((394474443775304 / 235794999 : ℚ)) * X ^ 5 + C ((246737191330972 / 235794999 : ℚ)) * X ^ 6 + C ((117263720517236 / 78598333 : ℚ)) * X ^ 7 + C ((201167097160774 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_030_poly_re :
    CU_030_0_pre + CU_030_1_pre + CU_030_2_pre = (0 : Polynomial ℚ) + Phi11 * CU_030_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_030_0_pre, CU_030_1_pre, CU_030_2_pre, CU_030_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_030_poly_im :
    CU_030_0_pim + CU_030_1_pim + CU_030_2_pim = (0 : Polynomial ℚ) + Phi11 * CU_030_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_030_0_pim, CU_030_1_pim, CU_030_2_pim, CU_030_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_030_eq :
    CU_coeff_030 = (0 : Ki) := by
  rw [CU_coeff_030_sum, CU_coeff_030_poly_re,
    CU_coeff_030_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
