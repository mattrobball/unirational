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

def CV_210_0_pre : Polynomial ℚ := C ((-10804509017 / 785450721 : ℚ)) + C ((1914919288952 / 8639957931 : ℚ)) * X + C ((3633811161092 / 8639957931 : ℚ)) * X ^ 2 + C ((5973205137598 / 8639957931 : ℚ)) * X ^ 3 + C ((10355169178714 / 8639957931 : ℚ)) * X ^ 4 + C ((13181324917031 / 8639957931 : ℚ)) * X ^ 5 + C ((5326638938033 / 2879985977 : ℚ)) * X ^ 6 + C ((17087349559837 / 8639957931 : ℚ)) * X ^ 7 + C ((5296777626534 / 2879985977 : ℚ)) * X ^ 8 + C ((5025479265315 / 2879985977 : ℚ)) * X ^ 9 + C ((14321258265442 / 8639957931 : ℚ)) * X ^ 10 + C ((14231753146456 / 8639957931 : ℚ)) * X ^ 11 + C ((12406338976490 / 8639957931 : ℚ)) * X ^ 12 + C ((11442626634853 / 8639957931 : ℚ)) * X ^ 13 + C ((9917127742004 / 8639957931 : ℚ)) * X ^ 14 + C ((2108083245062 / 2879985977 : ℚ)) * X ^ 15 + C ((3918941482175 / 8639957931 : ℚ)) * X ^ 16 + C ((1120349585107 / 8639957931 : ℚ)) * X ^ 17 + C ((-135976881979 / 2879985977 : ℚ)) * X ^ 18
def CV_210_0_pim : Polynomial ℚ := C ((-1846291355383 / 8639957931 : ℚ)) + C ((-3692582710766 / 8639957931 : ℚ)) * X + C ((-420858190211 / 785450721 : ℚ)) * X ^ 2 + C ((-6570631438621 / 8639957931 : ℚ)) * X ^ 3 + C ((-6570730749500 / 8639957931 : ℚ)) * X ^ 4 + C ((-4843090525079 / 8639957931 : ℚ)) * X ^ 5 + C ((-3030666199148 / 8639957931 : ℚ)) * X ^ 6 + C ((633582034501 / 8639957931 : ℚ)) * X ^ 7 + C ((804428869693 / 2879985977 : ℚ)) * X ^ 8 + C ((797204150747 / 2879985977 : ℚ)) * X ^ 9 + C ((1798402803047 / 8639957931 : ℚ)) * X ^ 10 + C ((929662140050 / 2879985977 : ℚ)) * X ^ 11 + C ((3779570037253 / 8639957931 : ℚ)) * X ^ 12 + C ((4123217769614 / 8639957931 : ℚ)) * X ^ 13 + C ((6042734959076 / 8639957931 : ℚ)) * X ^ 14 + C ((6343301051957 / 8639957931 : ℚ)) * X ^ 15 + C ((1805253593865 / 2879985977 : ℚ)) * X ^ 16 + C ((4343386072166 / 8639957931 : ℚ)) * X ^ 17 + C ((493079264192 / 2879985977 : ℚ)) * X ^ 18
theorem CV_210_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_110 - CV_0_im_100 * Fplus_dU_im_110 = CV_210_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100, CV_0_im_100, Fplus_dU_re_110, Fplus_dU_im_110, CV_210_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_210_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_110 + CV_0_im_100 * Fplus_dU_re_110 = CV_210_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100, CV_0_im_100, Fplus_dU_re_110, Fplus_dU_im_110, CV_210_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_210_0_mul :
    CV_0_c_100 * Fplus_dU_c_110 = ofLadj CV_210_0_pre CV_210_0_pim := by
  rw [CV_0_c_100, Fplus_dU_c_110, ofLadj_mul, CV_210_0_pre_eq, CV_210_0_pim_eq]

def CV_210_1_pre : Polynomial ℚ := C ((-174804263555 / 8639957931 : ℚ)) + C ((6545769050000 / 2879985977 : ℚ)) * X + C ((12313848010318 / 2879985977 : ℚ)) * X ^ 2 + C ((21279181768687 / 2879985977 : ℚ)) * X ^ 3 + C ((3157908955038 / 261816907 : ℚ)) * X ^ 4 + C ((44760211933433 / 2879985977 : ℚ)) * X ^ 5 + C ((14902466052779 / 785450721 : ℚ)) * X ^ 6 + C ((187643836993390 / 8639957931 : ℚ)) * X ^ 7 + C ((17340645441800 / 785450721 : ℚ)) * X ^ 8 + C ((197362585605872 / 8639957931 : ℚ)) * X ^ 9 + C ((202582928067286 / 8639957931 : ℚ)) * X ^ 10 + C ((68191270990046 / 2879985977 : ℚ)) * X ^ 11 + C ((182945620917286 / 8639957931 : ℚ)) * X ^ 12 + C ((160421041574918 / 8639957931 : ℚ)) * X ^ 13 + C ((126909554553739 / 8639957931 : ℚ)) * X ^ 14 + C ((80395603921076 / 8639957931 : ℚ)) * X ^ 15 + C ((525515225143 / 97078179 : ℚ)) * X ^ 16 + C ((17124364257457 / 8639957931 : ℚ)) * X ^ 17 + C ((-3037237556060 / 8639957931 : ℚ)) * X ^ 18
def CV_210_1_pim : Polynomial ℚ := C ((-18187043739575 / 8639957931 : ℚ)) + C ((-36374087479150 / 8639957931 : ℚ)) * X + C ((-48944205300610 / 8639957931 : ℚ)) * X ^ 2 + C ((-68941692992570 / 8639957931 : ℚ)) * X ^ 3 + C ((-23979232527585 / 2879985977 : ℚ)) * X ^ 4 + C ((-64157039214067 / 8639957931 : ℚ)) * X ^ 5 + C ((-56383537044029 / 8639957931 : ℚ)) * X ^ 6 + C ((-11206704971530 / 2879985977 : ℚ)) * X ^ 7 + C ((-5819243261734 / 2879985977 : ℚ)) * X ^ 8 + C ((-16588047314456 / 8639957931 : ℚ)) * X ^ 9 + C ((-12150289661935 / 8639957931 : ℚ)) * X ^ 10 + C ((4174188022060 / 2879985977 : ℚ)) * X ^ 11 + C ((37195417794295 / 8639957931 : ℚ)) * X ^ 12 + C ((54203293268276 / 8639957931 : ℚ)) * X ^ 13 + C ((75070463430982 / 8639957931 : ℚ)) * X ^ 14 + C ((25094751986021 / 2879985977 : ℚ)) * X ^ 15 + C ((61792528120853 / 8639957931 : ℚ)) * X ^ 16 + C ((15806362930151 / 2879985977 : ℚ)) * X ^ 17 + C ((18944597192492 / 8639957931 : ℚ)) * X ^ 18
theorem CV_210_1_pre_eq :
    CV_1_re_100 * Fplus_dV_re_110 - CV_1_im_100 * Fplus_dV_im_110 = CV_210_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100, CV_1_im_100, Fplus_dV_re_110, Fplus_dV_im_110, CV_210_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_210_1_pim_eq :
    CV_1_re_100 * Fplus_dV_im_110 + CV_1_im_100 * Fplus_dV_re_110 = CV_210_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100, CV_1_im_100, Fplus_dV_re_110, Fplus_dV_im_110, CV_210_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_210_1_mul :
    CV_1_c_100 * Fplus_dV_c_110 = ofLadj CV_210_1_pre CV_210_1_pim := by
  rw [CV_1_c_100, Fplus_dV_c_110, ofLadj_mul, CV_210_1_pre_eq, CV_210_1_pim_eq]

def CV_210_2_pre : Polynomial ℚ := C ((1199956179602 / 2879985977 : ℚ)) + C ((16801282734760 / 2879985977 : ℚ)) * X + C ((34088911832507 / 2879985977 : ℚ)) * X ^ 2 + C ((167709010581188 / 8639957931 : ℚ)) * X ^ 3 + C ((249875147387861 / 8639957931 : ℚ)) * X ^ 4 + C ((296667364485689 / 8639957931 : ℚ)) * X ^ 5 + C ((111560930654755 / 2879985977 : ℚ)) * X ^ 6 + C ((355493725328567 / 8639957931 : ℚ)) * X ^ 7 + C ((338921304042466 / 8639957931 : ℚ)) * X ^ 8 + C ((332524865367347 / 8639957931 : ℚ)) * X ^ 9 + C ((327626133638444 / 8639957931 : ℚ)) * X ^ 10 + C ((322232125540730 / 8639957931 : ℚ)) * X ^ 11 + C ((277222285434164 / 8639957931 : ℚ)) * X ^ 12 + C ((230258129869826 / 8639957931 : ℚ)) * X ^ 13 + C ((171212293461278 / 8639957931 : ℚ)) * X ^ 14 + C ((94926441194917 / 8639957931 : ℚ)) * X ^ 15 + C ((51592090908139 / 8639957931 : ℚ)) * X ^ 16 + C ((4525554476521 / 2879985977 : ℚ)) * X ^ 17 + C ((-10692136745789 / 8639957931 : ℚ)) * X ^ 18
def CV_210_2_pim : Polynomial ℚ := C ((-33992764552678 / 8639957931 : ℚ)) + C ((-67985529105356 / 8639957931 : ℚ)) * X + C ((-80221220500105 / 8639957931 : ℚ)) * X ^ 2 + C ((-94839172906420 / 8639957931 : ℚ)) * X ^ 3 + C ((-71354362490551 / 8639957931 : ℚ)) * X ^ 4 + C ((-8439494587785 / 2879985977 : ℚ)) * X ^ 5 + C ((3881515345365 / 2879985977 : ℚ)) * X ^ 6 + C ((65836119003076 / 8639957931 : ℚ)) * X ^ 7 + C ((32363045502701 / 2879985977 : ℚ)) * X ^ 8 + C ((96147730963007 / 8639957931 : ℚ)) * X ^ 9 + C ((91922834398420 / 8639957931 : ℚ)) * X ^ 10 + C ((39905372110908 / 2879985977 : ℚ)) * X ^ 11 + C ((147509398267028 / 8639957931 : ℚ)) * X ^ 12 + C ((51840064365730 / 2879985977 : ℚ)) * X ^ 13 + C ((169196739958409 / 8639957931 : ℚ)) * X ^ 14 + C ((4498534420656 / 261816907 : ℚ)) * X ^ 15 + C ((107807755731685 / 8639957931 : ℚ)) * X ^ 16 + C ((25770961851889 / 2879985977 : ℚ)) * X ^ 17 + C ((28513311165919 / 8639957931 : ℚ)) * X ^ 18
theorem CV_210_2_pre_eq :
    CV_2_re_100 * Fplus_dW_re_110 - CV_2_im_100 * Fplus_dW_im_110 = CV_210_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100, CV_2_im_100, Fplus_dW_re_110, Fplus_dW_im_110, CV_210_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_210_2_pim_eq :
    CV_2_re_100 * Fplus_dW_im_110 + CV_2_im_100 * Fplus_dW_re_110 = CV_210_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100, CV_2_im_100, Fplus_dW_re_110, Fplus_dW_im_110, CV_210_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_210_2_mul :
    CV_2_c_100 * Fplus_dW_c_110 = ofLadj CV_210_2_pre CV_210_2_pim := by
  rw [CV_2_c_100, Fplus_dW_c_110, ofLadj_mul, CV_210_2_pre_eq, CV_210_2_pim_eq]

theorem CV_210_3_mul : CV_3_c_200 = ofLadj CV_3_re_200 CV_3_im_200 := rfl

@[expose] public def CV_coeff_210 : Ki := CV_0_c_100 * Fplus_dU_c_110 + CV_1_c_100 * Fplus_dV_c_110 + CV_2_c_100 * Fplus_dW_c_110 + CV_3_c_200

theorem CV_coeff_210_sum :
    CV_coeff_210 = ofLadj (CV_210_0_pre + CV_210_1_pre + CV_210_2_pre + CV_3_re_200) (CV_210_0_pim + CV_210_1_pim + CV_210_2_pim + CV_3_im_200) := by
  simp only [CV_coeff_210, CV_210_0_mul, CV_210_1_mul, CV_210_2_mul, CV_210_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_210_0_pre CV_210_0_pim CV_210_1_pre CV_210_1_pim CV_210_2_pre CV_210_2_pim CV_3_re_200 CV_3_im_200

def CV_210_qre : Polynomial ℚ := C ((3492628313848 / 8639957931 : ℚ)) + C ((68463446329384 / 8639957931 : ℚ)) * X + C ((23484149082781 / 2879985977 : ℚ)) * X ^ 2 + C ((31360940774192 / 2879985977 : ℚ)) * X ^ 3 + C ((126392680905842 / 8639957931 : ℚ)) * X ^ 4 + C ((79364407423138 / 8639957931 : ℚ)) * X ^ 5 + C ((23486836718638 / 2879985977 : ℚ)) * X ^ 6 + C ((15319560739971 / 2879985977 : ℚ)) * X ^ 7 + C ((-14137304947786 / 8639957931 : ℚ)) * X ^ 8
def CV_210_qim : Polynomial ℚ := C ((-53456719279522 / 8639957931 : ℚ)) + C ((-53456719279522 / 8639957931 : ℚ)) * X + C ((-8454106012168 / 2879985977 : ℚ)) * X ^ 2 + C ((-36463234213387 / 8639957931 : ℚ)) * X ^ 3 + C ((6743581818933 / 2879985977 : ℚ)) * X ^ 4 + C ((5005740750685 / 785450721 : ℚ)) * X ^ 5 + C ((45940684215847 / 8639957931 : ℚ)) * X ^ 6 + C ((80138214267299 / 8639957931 : ℚ)) * X ^ 7 + C ((16312382050329 / 2879985977 : ℚ)) * X ^ 8
theorem CV_coeff_210_poly_re :
    CV_210_0_pre + CV_210_1_pre + CV_210_2_pre + CV_3_re_200 = (0 : Polynomial ℚ) + Phi11 * CV_210_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_210_0_pre, CV_210_1_pre, CV_210_2_pre, CV_3_re_200, CV_210_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_210_poly_im :
    CV_210_0_pim + CV_210_1_pim + CV_210_2_pim + CV_3_im_200 = (0 : Polynomial ℚ) + Phi11 * CV_210_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_210_0_pim, CV_210_1_pim, CV_210_2_pim, CV_3_im_200, CV_210_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CV_coeff_210_eq :
    CV_coeff_210 = (0 : Ki) := by
  rw [CV_coeff_210_sum, CV_coeff_210_poly_re,
    CV_coeff_210_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
