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

def CU_201_0_pre : Polynomial ℚ := C ((-35031570101136 / 78598333 : ℚ)) + C ((30856246221194 / 78598333 : ℚ)) * X ^ 2 + C ((88532791993760 / 78598333 : ℚ)) * X ^ 3 + C ((272234580652334 / 78598333 : ℚ)) * X ^ 4 + C ((457068128091303 / 78598333 : ℚ)) * X ^ 5 + C ((647382330613356 / 78598333 : ℚ)) * X ^ 6 + C ((72907650820665 / 7145303 : ℚ)) * X ^ 7 + C ((860440185123489 / 78598333 : ℚ)) * X ^ 8 + C ((885424241927073 / 78598333 : ℚ)) * X ^ 9 + C ((904498733450914 / 78598333 : ℚ)) * X ^ 10 + C ((946635484305008 / 78598333 : ℚ)) * X ^ 11 + C ((904498733450914 / 78598333 : ℚ)) * X ^ 12 + C ((854567995705879 / 78598333 : ℚ)) * X ^ 13 + C ((771907393129729 / 78598333 : ℚ)) * X ^ 14 + C ((565244792319193 / 78598333 : ℚ)) * X ^ 15 + C ((366770619280726 / 78598333 : ℚ)) * X ^ 16 + C ((176456416758673 / 78598333 : ℚ)) * X ^ 17 + C ((293348875572 / 649573 : ℚ)) * X ^ 18
def CU_201_0_pim : Polynomial ℚ := C ((-119348708681676 / 78598333 : ℚ)) + C ((-238697417363352 / 78598333 : ℚ)) * X + C ((-388087449649808 / 78598333 : ℚ)) * X ^ 2 + C ((-590677604196398 / 78598333 : ℚ)) * X ^ 3 + C ((-65077899000690 / 7145303 : ℚ)) * X ^ 4 + C ((-775770310434021 / 78598333 : ℚ)) * X ^ 5 + C ((-791708138272250 / 78598333 : ℚ)) * X ^ 6 + C ((-676477771318277 / 78598333 : ℚ)) * X ^ 7 + C ((-601299036310003 / 78598333 : ℚ)) * X ^ 8 + C ((-597706874557867 / 78598333 : ℚ)) * X ^ 9 + C ((-581174473729360 / 78598333 : ℚ)) * X ^ 10 + C ((-39782902893892 / 7145303 : ℚ)) * X ^ 11 + C ((-294049389936264 / 78598333 : ℚ)) * X ^ 12 + C ((-128126956821301 / 78598333 : ℚ)) * X ^ 13 + C ((7095941770675 / 7145303 : ℚ)) * X ^ 14 + C ((192747925214465 / 78598333 : ℚ)) * X ^ 15 + C ((21038737779324 / 7145303 : ℚ)) * X ^ 16 + C ((20193732009521 / 7145303 : ℚ)) * X ^ 17 + C ((85665454082426 / 78598333 : ℚ)) * X ^ 18
theorem CU_201_0_pre_eq :
    CU_0_re_001 * Fplus_dU_re_200 - CU_0_im_001 * Fplus_dU_im_200 = CU_201_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_200, Fplus_dU_im_200, CU_201_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_201_0_pim_eq :
    CU_0_re_001 * Fplus_dU_im_200 + CU_0_im_001 * Fplus_dU_re_200 = CU_201_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_200, Fplus_dU_im_200, CU_201_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_201_0_mul :
    CU_0_c_001 * Fplus_dU_c_200 = ofLadj CU_201_0_pre CU_201_0_pim := by
  rw [CU_0_c_001, Fplus_dU_c_200, ofLadj_mul, CU_201_0_pre_eq, CU_201_0_pim_eq]

def CU_201_1_pre : Polynomial ℚ := C ((-503332599958 / 78598333 : ℚ)) + C ((72439332705408 / 78598333 : ℚ)) * X + C ((434558418100022 / 235794999 : ℚ)) * X ^ 2 + C ((708215671640717 / 235794999 : ℚ)) * X ^ 3 + C ((1197294879937355 / 235794999 : ℚ)) * X ^ 4 + C ((1532759820780020 / 235794999 : ℚ)) * X ^ 5 + C ((1848498977088782 / 235794999 : ℚ)) * X ^ 6 + C ((661972531957677 / 78598333 : ℚ)) * X ^ 7 + C ((616167299007148 / 78598333 : ℚ)) * X ^ 8 + C ((1750191466551872 / 235794999 : ℚ)) * X ^ 9 + C ((1675116311076553 / 235794999 : ℚ)) * X ^ 10 + C ((149877552313868 / 21435909 : ℚ)) * X ^ 11 + C ((1457798312960329 / 235794999 : ℚ)) * X ^ 12 + C ((438544349483950 / 78598333 : ℚ)) * X ^ 13 + C ((1140286225380727 / 235794999 : ℚ)) * X ^ 14 + C ((741564267595996 / 235794999 : ℚ)) * X ^ 15 + C ((459795930151535 / 235794999 : ℚ)) * X ^ 16 + C ((13096070349343 / 21435909 : ℚ)) * X ^ 17 + C ((-15686149446560 / 78598333 : ℚ)) * X ^ 18
def CU_201_1_pim : Polynomial ℚ := C ((-68702463481892 / 78598333 : ℚ)) + C ((-137404926963784 / 78598333 : ℚ)) * X + C ((-48439988544902 / 21435909 : ℚ)) * X ^ 2 + C ((-730956615397961 / 235794999 : ℚ)) * X ^ 3 + C ((-735192159476015 / 235794999 : ℚ)) * X ^ 4 + C ((-539923524808510 / 235794999 : ℚ)) * X ^ 5 + C ((-107872114920858 / 78598333 : ℚ)) * X ^ 6 + C ((91373707315447 / 235794999 : ℚ)) * X ^ 7 + C ((316617214964246 / 235794999 : ℚ)) * X ^ 8 + C ((100828991449876 / 78598333 : ℚ)) * X ^ 9 + C ((237436252488493 / 235794999 : ℚ)) * X ^ 10 + C ((116080521065396 / 78598333 : ℚ)) * X ^ 11 + C ((459046873903883 / 235794999 : ℚ)) * X ^ 12 + C ((514621245145318 / 235794999 : ℚ)) * X ^ 13 + C ((232869248644913 / 78598333 : ℚ)) * X ^ 14 + C ((744098838351922 / 235794999 : ℚ)) * X ^ 15 + C ((210799701035357 / 78598333 : ℚ)) * X ^ 16 + C ((515409111966037 / 235794999 : ℚ)) * X ^ 17 + C ((61329319769890 / 78598333 : ℚ)) * X ^ 18
theorem CU_201_1_pre_eq :
    CU_1_re_001 * Fplus_dV_re_200 - CU_1_im_001 * Fplus_dV_im_200 = CU_201_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_200, Fplus_dV_im_200, CU_201_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_201_1_pim_eq :
    CU_1_re_001 * Fplus_dV_im_200 + CU_1_im_001 * Fplus_dV_re_200 = CU_201_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_200, Fplus_dV_im_200, CU_201_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_201_1_mul :
    CU_1_c_001 * Fplus_dV_c_200 = ofLadj CU_201_1_pre CU_201_1_pim := by
  rw [CU_1_c_001, Fplus_dV_c_200, ofLadj_mul, CU_201_1_pre_eq, CU_201_1_pim_eq]

def CU_201_2_pre : Polynomial ℚ := C ((-10734619894712 / 78598333 : ℚ)) + C ((-76690188205248 / 78598333 : ℚ)) * X + C ((-433748129757368 / 235794999 : ℚ)) * X ^ 2 + C ((-682424580444710 / 235794999 : ℚ)) * X ^ 3 + C ((-971411296616360 / 235794999 : ℚ)) * X ^ 4 + C ((-371113387531248 / 78598333 : ℚ)) * X ^ 5 + C ((-1219094132738024 / 235794999 : ℚ)) * X ^ 6 + C ((-422654160533120 / 78598333 : ℚ)) * X ^ 7 + C ((-106770547996129 / 21435909 : ℚ)) * X ^ 8 + C ((-385559229337471 / 78598333 : ℚ)) * X ^ 9 + C ((-381023940570835 / 78598333 : ℚ)) * X ^ 10 + C ((-368597870029222 / 78598333 : ℚ)) * X ^ 11 + C ((-304333752365587 / 78598333 : ℚ)) * X ^ 12 + C ((-722929558255045 / 235794999 : ℚ)) * X ^ 13 + C ((-164017149170903 / 78598333 : ℚ)) * X ^ 14 + C ((-219429925805080 / 235794999 : ℚ)) * X ^ 15 + C ((-87238098918154 / 235794999 : ℚ)) * X ^ 16 + C ((18515871226126 / 235794999 : ℚ)) * X ^ 17 + C ((25707086392640 / 78598333 : ℚ)) * X ^ 18
def CU_201_2_pim : Polynomial ℚ := C ((103152316044104 / 235794999 : ℚ)) + C ((206304632088208 / 235794999 : ℚ)) * X + C ((196387262865712 / 235794999 : ℚ)) * X ^ 2 + C ((195755983298618 / 235794999 : ℚ)) * X ^ 3 + C ((53024704238540 / 235794999 : ℚ)) * X ^ 4 + C ((-167554777732660 / 235794999 : ℚ)) * X ^ 5 + C ((-112219500028824 / 78598333 : ℚ)) * X ^ 6 + C ((-552248218245208 / 235794999 : ℚ)) * X ^ 7 + C ((-20346555616457 / 7145303 : ℚ)) * X ^ 8 + C ((-20269144217013 / 7145303 : ℚ)) * X ^ 9 + C ((-657106486987591 / 235794999 : ℚ)) * X ^ 10 + C ((-742988624683304 / 235794999 : ℚ)) * X ^ 11 + C ((-276290254126339 / 78598333 : ℚ)) * X ^ 12 + C ((-807178120982683 / 235794999 : ℚ)) * X ^ 13 + C ((-803992265233937 / 235794999 : ℚ)) * X ^ 14 + C ((-222907769630196 / 78598333 : ℚ)) * X ^ 15 + C ((-463281422373518 / 235794999 : ℚ)) * X ^ 16 + C ((-104059305695250 / 78598333 : ℚ)) * X ^ 17 + C ((-111725794381144 / 235794999 : ℚ)) * X ^ 18
theorem CU_201_2_pre_eq :
    CU_2_re_001 * Fplus_dW_re_200 - CU_2_im_001 * Fplus_dW_im_200 = CU_201_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_200, Fplus_dW_im_200, CU_201_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_201_2_pim_eq :
    CU_2_re_001 * Fplus_dW_im_200 + CU_2_im_001 * Fplus_dW_re_200 = CU_201_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_200, Fplus_dW_im_200, CU_201_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_201_2_mul :
    CU_2_c_001 * Fplus_dW_c_200 = ofLadj CU_201_2_pre CU_201_2_pim := by
  rw [CU_2_c_001, Fplus_dW_c_200, ofLadj_mul, CU_201_2_pre_eq, CU_201_2_pim_eq]

theorem CU_201_3_mul : CU_3_c_101 = ofLadj CU_3_re_101 CU_3_im_101 := rfl

@[expose] public def CU_coeff_201 : Ki := CU_0_c_001 * Fplus_dU_c_200 + CU_1_c_001 * Fplus_dV_c_200 + CU_2_c_001 * Fplus_dW_c_200 + CU_3_c_101

theorem CU_coeff_201_sum :
    CU_coeff_201 = ofLadj (CU_201_0_pre + CU_201_1_pre + CU_201_2_pre + CU_3_re_101) (CU_201_0_pim + CU_201_1_pim + CU_201_2_pim + CU_3_im_101) := by
  simp only [CU_coeff_201, CU_201_0_mul, CU_201_1_mul, CU_201_2_mul, CU_201_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_201_0_pre CU_201_0_pim CU_201_1_pre CU_201_1_pim CU_201_2_pre CU_201_2_pim CU_3_re_101 CU_3_im_101

def CU_201_qre : Polynomial ℚ := C ((-45741742854372 / 78598333 : ℚ)) + C ((342899895492 / 649573 : ℚ)) * X + C ((101885778901868 / 235794999 : ℚ)) * X ^ 2 + C ((192450520057237 / 235794999 : ℚ)) * X ^ 3 + C ((746088238508710 / 235794999 : ℚ)) * X ^ 4 + C ((744999029672936 / 235794999 : ℚ)) * X ^ 5 + C ((780927793730641 / 235794999 : ℚ)) * X ^ 6 + C ((185131147558014 / 78598333 : ℚ)) * X ^ 7 + C ((45516150890292 / 78598333 : ℚ)) * X ^ 8
def CU_201_qim : Polynomial ℚ := C ((-455610798701626 / 235794999 : ℚ)) + C ((-455610798701626 / 235794999 : ℚ)) * X + C ((-52275846543878 / 21435909 : ℚ)) * X ^ 2 + C ((-805719305434345 / 235794999 : ℚ)) * X ^ 3 + C ((-174945915323884 / 78598333 : ℚ)) * X ^ 4 + C ((-69925574115172 / 78598333 : ℚ)) * X ^ 5 + C ((-2076107914745 / 78598333 : ℚ)) * X ^ 6 + C ((540365824018676 / 235794999 : ℚ)) * X ^ 7 + C ((329258527175804 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_201_poly_re :
    CU_201_0_pre + CU_201_1_pre + CU_201_2_pre + CU_3_re_101 = (0 : Polynomial ℚ) + Phi11 * CU_201_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_201_0_pre, CU_201_1_pre, CU_201_2_pre, CU_3_re_101, CU_201_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_201_poly_im :
    CU_201_0_pim + CU_201_1_pim + CU_201_2_pim + CU_3_im_101 = (0 : Polynomial ℚ) + Phi11 * CU_201_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_201_0_pim, CU_201_1_pim, CU_201_2_pim, CU_3_im_101, CU_201_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CU_coeff_201_eq :
    CU_coeff_201 = (0 : Ki) := by
  rw [CU_coeff_201_sum, CU_coeff_201_poly_re,
    CU_coeff_201_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
