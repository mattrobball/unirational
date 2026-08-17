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

def CW_021_0_pre : Polynomial ℚ := C ((1945670275616 / 8639957931 : ℚ)) + C ((44638992220160 / 8639957931 : ℚ)) * X + C ((87962152688012 / 8639957931 : ℚ)) * X ^ 2 + C ((146669150873660 / 8639957931 : ℚ)) * X ^ 3 + C ((73094877615450 / 2879985977 : ℚ)) * X ^ 4 + C ((257428248641342 / 8639957931 : ℚ)) * X ^ 5 + C ((293658285547232 / 8639957931 : ℚ)) * X ^ 6 + C ((310229115314608 / 8639957931 : ℚ)) * X ^ 7 + C ((295666829002574 / 8639957931 : ℚ)) * X ^ 8 + C ((289990946175718 / 8639957931 : ℚ)) * X ^ 9 + C ((95253819557320 / 2879985977 : ℚ)) * X ^ 10 + C ((94029788209568 / 2879985977 : ℚ)) * X ^ 11 + C ((241122466451800 / 8639957931 : ℚ)) * X ^ 12 + C ((202028793487706 / 8639957931 : ℚ)) * X ^ 13 + C ((49665892709638 / 2879985977 : ℚ)) * X ^ 14 + C ((81465993727054 / 8639957931 : ℚ)) * X ^ 15 + C ((15473572359886 / 2879985977 : ℚ)) * X ^ 16 + C ((3396893391256 / 2879985977 : ℚ)) * X ^ 17 + C ((-3159496247068 / 2879985977 : ℚ)) * X ^ 18
def CW_021_0_pim : Polynomial ℚ := C ((-10207531468952 / 2879985977 : ℚ)) + C ((-20415062937904 / 2879985977 : ℚ)) * X + C ((-71053826823952 / 8639957931 : ℚ)) * X ^ 2 + C ((-86859277449904 / 8639957931 : ℚ)) * X ^ 3 + C ((-63296845471810 / 8639957931 : ℚ)) * X ^ 4 + C ((-8503226040686 / 2879985977 : ℚ)) * X ^ 5 + C ((2151603600400 / 2879985977 : ℚ)) * X ^ 6 + C ((55340855287640 / 8639957931 : ℚ)) * X ^ 7 + C ((27001970521898 / 2879985977 : ℚ)) * X ^ 8 + C ((80181973357268 / 8639957931 : ℚ)) * X ^ 9 + C ((76564129958968 / 8639957931 : ℚ)) * X ^ 10 + C ((101669945866408 / 8639957931 : ℚ)) * X ^ 11 + C ((11525069252168 / 785450721 : ℚ)) * X ^ 12 + C ((132966556385788 / 8639957931 : ℚ)) * X ^ 13 + C ((49316022934438 / 2879985977 : ℚ)) * X ^ 14 + C ((126776312109010 / 8639957931 : ℚ)) * X ^ 15 + C ((93650140958386 / 8639957931 : ℚ)) * X ^ 16 + C ((67499429281576 / 8639957931 : ℚ)) * X ^ 17 + C ((7758126998088 / 2879985977 : ℚ)) * X ^ 18
theorem CW_021_0_pre_eq :
    CW_0_re_010 * Fplus_dU_re_011 - CW_0_im_010 * Fplus_dU_im_011 = CW_021_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_011, Fplus_dU_im_011, CW_021_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_021_0_pim_eq :
    CW_0_re_010 * Fplus_dU_im_011 + CW_0_im_010 * Fplus_dU_re_011 = CW_021_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_011, Fplus_dU_im_011, CW_021_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_021_0_mul :
    CW_0_c_010 * Fplus_dU_c_011 = ofLadj CW_021_0_pre CW_021_0_pim := by
  rw [CW_0_c_010, Fplus_dU_c_011, ofLadj_mul, CW_021_0_pre_eq, CW_021_0_pim_eq]

def CW_021_1_pre : Polynomial ℚ := C ((-2699804936732 / 8639957931 : ℚ)) + C ((-69511645258160 / 8639957931 : ℚ)) * X + C ((-136003716180388 / 8639957931 : ℚ)) * X ^ 2 + C ((-221080674662284 / 8639957931 : ℚ)) * X ^ 3 + C ((-334569861593906 / 8639957931 : ℚ)) * X ^ 4 + C ((-132773281182328 / 2879985977 : ℚ)) * X ^ 5 + C ((-449791510612058 / 8639957931 : ℚ)) * X ^ 6 + C ((-479749753619482 / 8639957931 : ℚ)) * X ^ 7 + C ((-457971907921702 / 8639957931 : ℚ)) * X ^ 8 + C ((-452378747854940 / 8639957931 : ℚ)) * X ^ 9 + C ((-448749307571242 / 8639957931 : ℚ)) * X ^ 10 + C ((-148149273111804 / 2879985977 : ℚ)) * X ^ 11 + C ((-379237662313082 / 8639957931 : ℚ)) * X ^ 12 + C ((-316375031674552 / 8639957931 : ℚ)) * X ^ 13 + C ((-78963744419806 / 2879985977 : ℚ)) * X ^ 14 + C ((-42699805035222 / 2879985977 : ℚ)) * X ^ 15 + C ((-22354520443026 / 2879985977 : ℚ)) * X ^ 16 + C ((-15591894264004 / 8639957931 : ℚ)) * X ^ 17 + C ((17080476919910 / 8639957931 : ℚ)) * X ^ 18
def CW_021_1_pim : Polynomial ℚ := C ((48247425062308 / 8639957931 : ℚ)) + C ((96494850124616 / 8639957931 : ℚ)) * X + C ((3323581705934 / 261816907 : ℚ)) * X ^ 2 + C ((45356726347722 / 2879985977 : ℚ)) * X ^ 3 + C ((35225247769952 / 2879985977 : ℚ)) * X ^ 4 + C ((41956381122896 / 8639957931 : ℚ)) * X ^ 5 + C ((-9071109753016 / 8639957931 : ℚ)) * X ^ 6 + C ((-83404490300668 / 8639957931 : ℚ)) * X ^ 7 + C ((-127637696991766 / 8639957931 : ℚ)) * X ^ 8 + C ((-126583622452420 / 8639957931 : ℚ)) * X ^ 9 + C ((-122962702947718 / 8639957931 : ℚ)) * X ^ 10 + C ((-166340876422892 / 8639957931 : ℚ)) * X ^ 11 + C ((-69906349966022 / 2879985977 : ℚ)) * X ^ 12 + C ((-219281476564570 / 8639957931 : ℚ)) * X ^ 13 + C ((-244619384772568 / 8639957931 : ℚ)) * X ^ 14 + C ((-72320688167070 / 2879985977 : ℚ)) * X ^ 15 + C ((-157459049674832 / 8639957931 : ℚ)) * X ^ 16 + C ((-111613124416216 / 8639957931 : ℚ)) * X ^ 17 + C ((-41496091229146 / 8639957931 : ℚ)) * X ^ 18
theorem CW_021_1_pre_eq :
    CW_1_re_010 * Fplus_dV_re_011 - CW_1_im_010 * Fplus_dV_im_011 = CW_021_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_011, Fplus_dV_im_011, CW_021_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_021_1_pim_eq :
    CW_1_re_010 * Fplus_dV_im_011 + CW_1_im_010 * Fplus_dV_re_011 = CW_021_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_011, Fplus_dV_im_011, CW_021_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_021_1_mul :
    CW_1_c_010 * Fplus_dV_c_011 = ofLadj CW_021_1_pre CW_021_1_pim := by
  rw [CW_1_c_010, Fplus_dV_c_011, ofLadj_mul, CW_021_1_pre_eq, CW_021_1_pim_eq]

def CW_021_2_pre : Polynomial ℚ := C ((-889652764744 / 8639957931 : ℚ)) + C ((-430165406560 / 8639957931 : ℚ)) * X + C ((-1999477100162 / 8639957931 : ℚ)) * X ^ 2 + C ((-1908747794840 / 8639957931 : ℚ)) * X ^ 3 + C ((-896500953668 / 2879985977 : ℚ)) * X ^ 4 + C ((-4484994416024 / 8639957931 : ℚ)) * X ^ 5 + C ((-3453863893552 / 8639957931 : ℚ)) * X ^ 6 + C ((-1544877733386 / 2879985977 : ℚ)) * X ^ 7 + C ((-4358397920704 / 8639957931 : ℚ)) * X ^ 8 + C ((-4686204070786 / 8639957931 : ℚ)) * X ^ 9 + C ((-3989808228950 / 8639957931 : ℚ)) * X ^ 10 + C ((-3351384074116 / 8639957931 : ℚ)) * X ^ 11 + C ((-3559642822390 / 8639957931 : ℚ)) * X ^ 12 + C ((-2686726970624 / 8639957931 : ℚ)) * X ^ 13 + C ((-2449650125864 / 8639957931 : ℚ)) * X ^ 14 + C ((-679173434328 / 2879985977 : ℚ)) * X ^ 15 + C ((-393746305654 / 8639957931 : ℚ)) * X ^ 16 + C ((-1424876828126 / 8639957931 : ℚ)) * X ^ 17 + C ((-30796654610 / 2879985977 : ℚ)) * X ^ 18
def CW_021_2_pim : Polynomial ℚ := C ((234637553284 / 8639957931 : ℚ)) + C ((469275106568 / 8639957931 : ℚ)) * X + C ((34545019436 / 261816907 : ℚ)) * X ^ 2 + C ((-239250673150 / 8639957931 : ℚ)) * X ^ 3 + C ((541713245184 / 2879985977 : ℚ)) * X ^ 4 + C ((-53805834828 / 2879985977 : ℚ)) * X ^ 5 + C ((-566174666440 / 8639957931 : ℚ)) * X ^ 6 + C ((-66916444400 / 785450721 : ℚ)) * X ^ 7 + C ((-348223710900 / 2879985977 : ℚ)) * X ^ 8 + C ((-1490735007284 / 8639957931 : ℚ)) * X ^ 9 + C ((-493113259730 / 2879985977 : ℚ)) * X ^ 10 + C ((-121530534592 / 785450721 : ℚ)) * X ^ 11 + C ((-1194331981834 / 8639957931 : ℚ)) * X ^ 12 + C ((-617882429520 / 2879985977 : ℚ)) * X ^ 13 + C ((-920474848606 / 8639957931 : ℚ)) * X ^ 14 + C ((-2126529738298 / 8639957931 : ℚ)) * X ^ 15 + C ((-895822117672 / 8639957931 : ℚ)) * X ^ 16 + C ((-193660788620 / 2879985977 : ℚ)) * X ^ 17 + C ((-322308587770 / 2879985977 : ℚ)) * X ^ 18
theorem CW_021_2_pre_eq :
    CW_2_re_010 * Fplus_dW_re_011 - CW_2_im_010 * Fplus_dW_im_011 = CW_021_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_011, Fplus_dW_im_011, CW_021_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_021_2_pim_eq :
    CW_2_re_010 * Fplus_dW_im_011 + CW_2_im_010 * Fplus_dW_re_011 = CW_021_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_011, Fplus_dW_im_011, CW_021_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_021_2_mul :
    CW_2_c_010 * Fplus_dW_c_011 = ofLadj CW_021_2_pre CW_021_2_pim := by
  rw [CW_2_c_010, Fplus_dW_c_011, ofLadj_mul, CW_021_2_pre_eq, CW_021_2_pim_eq]

def CW_021_3_pre : Polynomial ℚ := C ((25299646012 / 785450721 : ℚ)) + C ((29679465400 / 261816907 : ℚ)) * X ^ 2 + C ((46482931152 / 261816907 : ℚ)) * X ^ 3 + C ((7085126324 / 23801537 : ℚ)) * X ^ 4 + C ((256198057804 / 785450721 : ℚ)) * X ^ 5 + C ((256198057804 / 785450721 : ℚ)) * X ^ 6 + C ((7085126324 / 23801537 : ℚ)) * X ^ 7 + C ((46482931152 / 261816907 : ℚ)) * X ^ 8 + C ((29679465400 / 261816907 : ℚ)) * X ^ 9
def CW_021_3_pim : Polynomial ℚ := C ((-717657768640 / 8639957931 : ℚ)) + C ((-1435315537280 / 8639957931 : ℚ)) * X + C ((-725918440488 / 2879985977 : ℚ)) * X ^ 2 + C ((-2012762530456 / 8639957931 : ℚ)) * X ^ 3 + C ((-683532642344 / 2879985977 : ℚ)) * X ^ 4 + C ((-304623313080 / 2879985977 : ℚ)) * X ^ 5 + C ((-521445598040 / 8639957931 : ℚ)) * X ^ 6 + C ((615282389752 / 8639957931 : ℚ)) * X ^ 7 + C ((577446993176 / 8639957931 : ℚ)) * X ^ 8 + C ((742439784184 / 8639957931 : ℚ)) * X ^ 9
theorem CW_021_3_neg_re : -CW_3_re_021 = CW_021_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_021, CW_021_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_021_3_neg_im : -CW_3_im_021 = CW_021_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_021, CW_021_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_021_3_mul : -CW_3_c_021 = ofLadj CW_021_3_pre CW_021_3_pim := by
  rw [CW_3_c_021, ofLadj_neg, CW_021_3_neg_re, CW_021_3_neg_im]

theorem CW_021_4_mul : CW_3_c_020 = ofLadj CW_3_re_020 CW_3_im_020 := rfl

@[expose] public def CW_coeff_021 : Ki := CW_0_c_010 * Fplus_dU_c_011 + CW_1_c_010 * Fplus_dV_c_011 + CW_2_c_010 * Fplus_dW_c_011 + (-CW_3_c_021) + CW_3_c_020

theorem CW_coeff_021_sum :
    CW_coeff_021 = ofLadj (CW_021_0_pre + CW_021_1_pre + CW_021_2_pre + CW_021_3_pre + CW_3_re_020) (CW_021_0_pim + CW_021_1_pim + CW_021_2_pim + CW_021_3_pim + CW_3_im_020) := by
  simp only [CW_coeff_021, CW_021_0_mul, CW_021_1_mul, CW_021_2_mul, CW_021_3_mul, CW_021_4_mul]
  simp [ofLadj_add, add_assoc]

def CW_021_qre : Polynomial ℚ := C ((-1267818347408 / 8639957931 : ℚ)) + C ((-2185000008832 / 785450721 : ℚ)) * X + C ((-24641873526202 / 8639957931 : ℚ)) * X ^ 2 + C ((-26689759901102 / 8639957931 : ℚ)) * X ^ 3 + C ((-13890754524924 / 2879985977 : ℚ)) * X ^ 4 + C ((-27634351126522 / 8639957931 : ℚ)) * X ^ 5 + C ((-14210499636712 / 8639957931 : ℚ)) * X ^ 6 + C ((-1303244466658 / 785450721 : ℚ)) * X ^ 7 + C ((7509598214876 / 8639957931 : ℚ)) * X ^ 8
def CW_021_qim : Polynomial ℚ := C ((6043284556352 / 2879985977 : ℚ)) + C ((6043284556352 / 2879985977 : ℚ)) * X + C ((1343649120430 / 2879985977 : ℚ)) * X ^ 2 + C ((9423223350518 / 8639957931 : ℚ)) * X ^ 3 + C ((-5279508687362 / 8639957931 : ℚ)) * X ^ 4 + C ((-2509777390580 / 785450721 : ℚ)) * X ^ 5 + C ((-20010053333618 / 8639957931 : ℚ)) * X ^ 6 + C ((-25506041502308 / 8639957931 : ℚ)) * X ^ 7 + C ((-19188635998192 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_021_poly_re :
    CW_021_0_pre + CW_021_1_pre + CW_021_2_pre + CW_021_3_pre + CW_3_re_020 = (0 : Polynomial ℚ) + Phi11 * CW_021_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_021_0_pre, CW_021_1_pre, CW_021_2_pre, CW_021_3_pre, CW_3_re_020, CW_021_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_021_poly_im :
    CW_021_0_pim + CW_021_1_pim + CW_021_2_pim + CW_021_3_pim + CW_3_im_020 = (0 : Polynomial ℚ) + Phi11 * CW_021_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_021_0_pim, CW_021_1_pim, CW_021_2_pim, CW_021_3_pim, CW_3_im_020, CW_021_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CW_coeff_021_eq :
    CW_coeff_021 = (0 : Ki) := by
  rw [CW_coeff_021_sum, CW_coeff_021_poly_re,
    CW_coeff_021_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
