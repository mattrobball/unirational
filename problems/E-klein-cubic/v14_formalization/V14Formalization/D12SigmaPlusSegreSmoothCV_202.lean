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

def CV_202_0_pre : Polynomial ℚ := C ((-407814850576 / 8639957931 : ℚ)) + C ((-9779161781248 / 8639957931 : ℚ)) * X + C ((-17864798326244 / 8639957931 : ℚ)) * X ^ 2 + C ((-28464303351268 / 8639957931 : ℚ)) * X ^ 3 + C ((-40910835278600 / 8639957931 : ℚ)) * X ^ 4 + C ((-46808412458675 / 8639957931 : ℚ)) * X ^ 5 + C ((-50773005270475 / 8639957931 : ℚ)) * X ^ 6 + C ((-53618603807863 / 8639957931 : ℚ)) * X ^ 7 + C ((-16127105021111 / 2879985977 : ℚ)) * X ^ 8 + C ((-16080392490948 / 2879985977 : ℚ)) * X ^ 9 + C ((-15625457889234 / 2879985977 : ℚ)) * X ^ 10 + C ((-15693487751288 / 2879985977 : ℚ)) * X ^ 11 + C ((-37097211886454 / 8639957931 : ℚ)) * X ^ 12 + C ((-30376379146600 / 8639957931 : ℚ)) * X ^ 13 + C ((-19917011712065 / 8639957931 : ℚ)) * X ^ 14 + C ((-8628566727211 / 8639957931 : ℚ)) * X ^ 15 + C ((-2901223114807 / 8639957931 : ℚ)) * X ^ 16 + C ((1063369696993 / 8639957931 : ℚ)) * X ^ 17 + C ((4079201802052 / 8639957931 : ℚ)) * X ^ 18
def CV_202_0_pim : Polynomial ℚ := C ((5025169397792 / 8639957931 : ℚ)) + C ((10050338795584 / 8639957931 : ℚ)) * X + C ((3039472716212 / 2879985977 : ℚ)) * X ^ 2 + C ((922252457312 / 785450721 : ℚ)) * X ^ 3 + C ((3801876491480 / 8639957931 : ℚ)) * X ^ 4 + C ((-5742534623197 / 8639957931 : ℚ)) * X ^ 5 + C ((-12027104438675 / 8639957931 : ℚ)) * X ^ 6 + C ((-21744147034106 / 8639957931 : ℚ)) * X ^ 7 + C ((-8852537701081 / 2879985977 : ℚ)) * X ^ 8 + C ((-8629608901807 / 2879985977 : ℚ)) * X ^ 9 + C ((-8578148951390 / 2879985977 : ℚ)) * X ^ 10 + C ((-9961277896864 / 2879985977 : ℚ)) * X ^ 11 + C ((-11344406842338 / 2879985977 : ℚ)) * X ^ 12 + C ((-32946920028815 / 8639957931 : ℚ)) * X ^ 13 + C ((-11101497504263 / 2879985977 : ℚ)) * X ^ 14 + C ((-9340781530490 / 2879985977 : ℚ)) * X ^ 15 + C ((-18302105821301 / 8639957931 : ℚ)) * X ^ 16 + C ((-4548527900809 / 2879985977 : ℚ)) * X ^ 17 + C ((-3752713451504 / 8639957931 : ℚ)) * X ^ 18
theorem CV_202_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_101 - CV_0_im_101 * Fplus_dU_im_101 = CV_202_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_202_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_101 + CV_0_im_101 * Fplus_dU_re_101 = CV_202_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_202_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_0_mul :
    CV_0_c_101 * Fplus_dU_c_101 = ofLadj CV_202_0_pre CV_202_0_pim := by
  rw [CV_0_c_101_def, Fplus_dU_c_101_def, ofLadj_mul, CV_202_0_pre_eq, CV_202_0_pim_eq]

def CV_202_1_pre : Polynomial ℚ := C ((31504941150966 / 2879985977 : ℚ)) + C ((-27833606199150 / 2879985977 : ℚ)) * X ^ 2 + C ((-79650632237787 / 2879985977 : ℚ)) * X ^ 3 + C ((-245035780933380 / 2879985977 : ℚ)) * X ^ 4 + C ((-411448757644216 / 2879985977 : ℚ)) * X ^ 5 + C ((-582666025448195 / 2879985977 : ℚ)) * X ^ 6 + C ((-721835849268808 / 2879985977 : ℚ)) * X ^ 7 + C ((-774471592112313 / 2879985977 : ℚ)) * X ^ 8 + C ((-796989258728610 / 2879985977 : ℚ)) * X ^ 9 + C ((-814122200440306 / 2879985977 : ℚ)) * X ^ 10 + C ((-852072077848272 / 2879985977 : ℚ)) * X ^ 11 + C ((-814122200440306 / 2879985977 : ℚ)) * X ^ 12 + C ((-769155652529460 / 2879985977 : ℚ)) * X ^ 13 + C ((-694820959874526 / 2879985977 : ℚ)) * X ^ 14 + C ((-508800028753924 / 2879985977 : ℚ)) * X ^ 15 + C ((-330097533500840 / 2879985977 : ℚ)) * X ^ 16 + C ((-158880265696861 / 2879985977 : ℚ)) * X ^ 17 + C ((-31999960418496 / 2879985977 : ℚ)) * X ^ 18
def CV_202_1_pim : Polynomial ℚ := C ((9768710956410 / 261816907 : ℚ)) + C ((19537421912820 / 261816907 : ℚ)) * X + C ((349358340695478 / 2879985977 : ℚ)) * X ^ 2 + C ((531726700152105 / 2879985977 : ℚ)) * X ^ 3 + C ((644417152713060 / 2879985977 : ℚ)) * X ^ 4 + C ((698322710854770 / 2879985977 : ℚ)) * X ^ 5 + C ((712645207422710 / 2879985977 : ℚ)) * X ^ 6 + C ((609033720423299 / 2879985977 : ℚ)) * X ^ 7 + C ((541347726978995 / 2879985977 : ℚ)) * X ^ 8 + C ((538145391559731 / 2879985977 : ℚ)) * X ^ 9 + C ((523254873142761 / 2879985977 : ℚ)) * X ^ 10 + C ((3256236985470 / 23801537 : ℚ)) * X ^ 11 + C ((264754477340979 / 2879985977 : ℚ)) * X ^ 12 + C ((115417259269551 / 2879985977 : ℚ)) * X ^ 13 + C ((-70153435606340 / 2879985977 : ℚ)) * X ^ 14 + C ((-173437290548651 / 2879985977 : ℚ)) * X ^ 15 + C ((-208198016937593 / 2879985977 : ℚ)) * X ^ 16 + C ((-199848909815127 / 2879985977 : ℚ)) * X ^ 17 + C ((-77092591062948 / 2879985977 : ℚ)) * X ^ 18
theorem CV_202_1_pre_eq :
    CV_0_re_002 * Fplus_dU_re_200 - CV_0_im_002 * Fplus_dU_im_200 = CV_202_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_202_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_1_pim_eq :
    CV_0_re_002 * Fplus_dU_im_200 + CV_0_im_002 * Fplus_dU_re_200 = CV_202_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_202_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_1_mul :
    CV_0_c_002 * Fplus_dU_c_200 = ofLadj CV_202_1_pre CV_202_1_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_200_def, ofLadj_mul, CV_202_1_pre_eq, CV_202_1_pim_eq]

def CV_202_2_pre : Polynomial ℚ := C ((-15995014043 / 97078179 : ℚ)) + C ((-67712998900 / 8825289 : ℚ)) * X + C ((-493275758222 / 32359393 : ℚ)) * X ^ 2 + C ((-824357016209 / 32359393 : ℚ)) * X ^ 3 + C ((-3692233465477 / 97078179 : ℚ)) * X ^ 4 + C ((-398222846051 / 8825289 : ℚ)) * X ^ 5 + C ((-4941889048330 / 97078179 : ℚ)) * X ^ 6 + C ((-1751467750664 / 32359393 : ℚ)) * X ^ 7 + C ((-453004508159 / 8825289 : ℚ)) * X ^ 8 + C ((-4880135021185 / 97078179 : ℚ)) * X ^ 9 + C ((-4815108038249 / 97078179 : ℚ)) * X ^ 10 + C ((-1587541075921 / 32359393 : ℚ)) * X ^ 11 + C ((-1356755016783 / 32359393 : ℚ)) * X ^ 12 + C ((-3400307746519 / 97078179 : ℚ)) * X ^ 13 + C ((-2509978541122 / 97078179 : ℚ)) * X ^ 14 + C ((-124897808558 / 8825289 : ℚ)) * X ^ 15 + C ((-740519985188 / 97078179 : ℚ)) * X ^ 16 + C ((-179082243419 / 97078179 : ℚ)) * X ^ 17 + C ((188293892377 / 97078179 : ℚ)) * X ^ 18
def CV_202_2_pim : Polynomial ℚ := C ((517829014795 / 97078179 : ℚ)) + C ((1035658029590 / 97078179 : ℚ)) * X + C ((1216923585838 / 97078179 : ℚ)) * X ^ 2 + C ((1448273134355 / 97078179 : ℚ)) * X ^ 3 + C ((368400297843 / 32359393 : ℚ)) * X ^ 4 + C ((393954406414 / 97078179 : ℚ)) * X ^ 5 + C ((-38060442525 / 32359393 : ℚ)) * X ^ 6 + C ((-322314247789 / 32359393 : ℚ)) * X ^ 7 + C ((-1402470322210 / 97078179 : ℚ)) * X ^ 8 + C ((-1394773219520 / 97078179 : ℚ)) * X ^ 9 + C ((-442516300057 / 32359393 : ℚ)) * X ^ 10 + C ((-584521382175 / 32359393 : ℚ)) * X ^ 11 + C ((-726526464293 / 32359393 : ℚ)) * X ^ 12 + C ((-764540209926 / 32359393 : ℚ)) * X ^ 13 + C ((-2517273075605 / 97078179 : ℚ)) * X ^ 14 + C ((-735636653283 / 32359393 : ℚ)) * X ^ 15 + C ((-1585860163826 / 97078179 : ℚ)) * X ^ 16 + C ((-388461059491 / 32359393 : ℚ)) * X ^ 17 + C ((-402818453773 / 97078179 : ℚ)) * X ^ 18
theorem CV_202_2_pre_eq :
    CV_1_re_101 * Fplus_dV_re_101 - CV_1_im_101 * Fplus_dV_im_101 = CV_202_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_202_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_2_pim_eq :
    CV_1_re_101 * Fplus_dV_im_101 + CV_1_im_101 * Fplus_dV_re_101 = CV_202_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_202_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_2_mul :
    CV_1_c_101 * Fplus_dV_c_101 = ofLadj CV_202_2_pre CV_202_2_pim := by
  rw [CV_1_c_101_def, Fplus_dV_c_101_def, ofLadj_mul, CV_202_2_pre_eq, CV_202_2_pim_eq]

def CV_202_3_pre : Polynomial ℚ := C ((390485983054 / 2879985977 : ℚ)) + C ((-217241626093000 / 8639957931 : ℚ)) * X + C ((-144912525155305 / 2879985977 : ℚ)) * X ^ 2 + C ((-21459123591064 / 261816907 : ℚ)) * X ^ 3 + C ((-1196944543842430 / 8639957931 : ℚ)) * X ^ 4 + C ((-1532405731774157 / 8639957931 : ℚ)) * X ^ 5 + C ((-1847857518461492 / 8639957931 : ℚ)) * X ^ 6 + C ((-1985309617800229 / 8639957931 : ℚ)) * X ^ 7 + C ((-1848062921011864 / 8639957931 : ℚ)) * X ^ 8 + C ((-1750008916576391 / 8639957931 : ℚ)) * X ^ 9 + C ((-1674723510112177 / 8639957931 : ℚ)) * X ^ 10 + C ((-1648192443119650 / 8639957931 : ℚ)) * X ^ 11 + C ((-485827294673059 / 2879985977 : ℚ)) * X ^ 12 + C ((-1315271341110476 / 8639957931 : ℚ)) * X ^ 13 + C ((-1139911842506752 / 8639957931 : ℚ)) * X ^ 14 + C ((-247184418378056 / 2879985977 : ℚ)) * X ^ 15 + C ((-459671191427884 / 8639957931 : ℚ)) * X ^ 16 + C ((-144219404740549 / 8639957931 : ℚ)) * X ^ 17 + C ((15603939607877 / 2879985977 : ℚ)) * X ^ 18
def CV_202_3_pim : Polynomial ℚ := C ((205938384109207 / 8639957931 : ℚ)) + C ((411876768218414 / 8639957931 : ℚ)) * X + C ((177510065838196 / 2879985977 : ℚ)) * X ^ 2 + C ((730454054003021 / 8639957931 : ℚ)) * X ^ 3 + C ((244839889344306 / 2879985977 : ℚ)) * X ^ 4 + C ((539637767611520 / 8639957931 : ℚ)) * X ^ 5 + C ((322972180944253 / 8639957931 : ℚ)) * X ^ 6 + C ((-8295131595661 / 785450721 : ℚ)) * X ^ 7 + C ((-316796800067926 / 8639957931 : ℚ)) * X ^ 8 + C ((-302487815995910 / 8639957931 : ℚ)) * X ^ 9 + C ((-237606223108490 / 8639957931 : ℚ)) * X ^ 10 + C ((-348244519564522 / 8639957931 : ℚ)) * X ^ 11 + C ((-152960938673518 / 2879985977 : ℚ)) * X ^ 12 + C ((-514654652429308 / 8639957931 : ℚ)) * X ^ 13 + C ((-698269524845725 / 8639957931 : ℚ)) * X ^ 14 + C ((-743830008393334 / 8639957931 : ℚ)) * X ^ 15 + C ((-632169068461883 / 8639957931 : ℚ)) * X ^ 16 + C ((-515053151004520 / 8639957931 : ℚ)) * X ^ 17 + C ((-61351827665981 / 2879985977 : ℚ)) * X ^ 18
theorem CV_202_3_pre_eq :
    CV_1_re_002 * Fplus_dV_re_200 - CV_1_im_002 * Fplus_dV_im_200 = CV_202_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_202_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_3_pim_eq :
    CV_1_re_002 * Fplus_dV_im_200 + CV_1_im_002 * Fplus_dV_re_200 = CV_202_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_202_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_3_mul :
    CV_1_c_002 * Fplus_dV_c_200 = ofLadj CV_202_3_pre CV_202_3_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_200_def, ofLadj_mul, CV_202_3_pre_eq, CV_202_3_pim_eq]

def CV_202_4_pre : Polynomial ℚ := C ((-8927485918990 / 8639957931 : ℚ)) + C ((-150305807459080 / 8639957931 : ℚ)) * X + C ((-99944056398832 / 2879985977 : ℚ)) * X ^ 2 + C ((-162335098435281 / 2879985977 : ℚ)) * X ^ 3 + C ((-739991427393875 / 8639957931 : ℚ)) * X ^ 4 + C ((-298037728738929 / 2879985977 : ℚ)) * X ^ 5 + C ((-345157877758124 / 2879985977 : ℚ)) * X ^ 6 + C ((-1129428527739442 / 8639957931 : ℚ)) * X ^ 7 + C ((-1110443927673632 / 8639957931 : ℚ)) * X ^ 8 + C ((-1125353674549513 / 8639957931 : ℚ)) * X ^ 9 + C ((-1136766164546663 / 8639957931 : ℚ)) * X ^ 10 + C ((-1132084016418598 / 8639957931 : ℚ)) * X ^ 11 + C ((-986460357087583 / 8639957931 : ℚ)) * X ^ 12 + C ((-6822491779777 / 71404611 : ℚ)) * X ^ 13 + C ((-623438632367789 / 8639957931 : ℚ)) * X ^ 14 + C ((-118922446879707 / 2879985977 : ℚ)) * X ^ 15 + C ((-64844173426532 / 2879985977 : ℚ)) * X ^ 16 + C ((-17724024407337 / 2879985977 : ℚ)) * X ^ 17 + C ((32669759706446 / 8639957931 : ℚ)) * X ^ 18
def CV_202_4_pim : Polynomial ℚ := C ((107766426472450 / 8639957931 : ℚ)) + C ((215532852944900 / 8639957931 : ℚ)) * X + C ((262381955925058 / 8639957931 : ℚ)) * X ^ 2 + C ((327966993254921 / 8639957931 : ℚ)) * X ^ 3 + C ((8625432490847 / 261816907 : ℚ)) * X ^ 4 + C ((171567505047977 / 8639957931 : ℚ)) * X ^ 5 + C ((84159018034361 / 8639957931 : ℚ)) * X ^ 6 + C ((-24681812807364 / 2879985977 : ℚ)) * X ^ 7 + C ((-165130209637097 / 8639957931 : ℚ)) * X ^ 8 + C ((-167283531802159 / 8639957931 : ℚ)) * X ^ 9 + C ((-177127584638629 / 8639957931 : ℚ)) * X ^ 10 + C ((-299365446536776 / 8639957931 : ℚ)) * X ^ 11 + C ((-421603308434923 / 8639957931 : ℚ)) * X ^ 12 + C ((-14493832250047 / 261816907 : ℚ)) * X ^ 13 + C ((-182011607915492 / 2879985977 : ℚ)) * X ^ 14 + C ((-496395023219729 / 8639957931 : ℚ)) * X ^ 15 + C ((-378656633711 / 8825289 : ℚ)) * X ^ 16 + C ((-268219718807921 / 8639957931 : ℚ)) * X ^ 17 + C ((-8854259153162 / 785450721 : ℚ)) * X ^ 18
theorem CV_202_4_pre_eq :
    CV_2_re_101 * Fplus_dW_re_101 - CV_2_im_101 * Fplus_dW_im_101 = CV_202_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_202_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_4_pim_eq :
    CV_2_re_101 * Fplus_dW_im_101 + CV_2_im_101 * Fplus_dW_re_101 = CV_202_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_202_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_4_mul :
    CV_2_c_101 * Fplus_dW_c_101 = ofLadj CV_202_4_pre CV_202_4_pim := by
  rw [CV_2_c_101_def, Fplus_dW_c_101_def, ofLadj_mul, CV_202_4_pre_eq, CV_202_4_pim_eq]

def CV_202_5_pre : Polynomial ℚ := C ((45055163976376 / 8639957931 : ℚ)) + C ((325609263570112 / 8639957931 : ℚ)) * X + C ((613522373769356 / 8639957931 : ℚ)) * X ^ 2 + C ((965205827676626 / 8639957931 : ℚ)) * X ^ 3 + C ((124946188964848 / 785450721 : ℚ)) * X ^ 4 + C ((525105075107087 / 2879985977 : ℚ)) * X ^ 5 + C ((52256253863380 / 261816907 : ℚ)) * X ^ 6 + C ((1794001294455424 / 8639957931 : ℚ)) * X ^ 7 + C ((553732490537159 / 2879985977 : ℚ)) * X ^ 8 + C ((545435559902697 / 2879985977 : ℚ)) * X ^ 9 + C ((1616680383089669 / 8639957931 : ℚ)) * X ^ 10 + C ((1564867153286840 / 8639957931 : ℚ)) * X ^ 11 + C ((1291071119519557 / 8639957931 : ℚ)) * X ^ 12 + C ((1022784305938735 / 8639957931 : ℚ)) * X ^ 13 + C ((63271967630441 / 785450721 : ℚ)) * X ^ 14 + C ((103394056835924 / 2879985977 : ℚ)) * X ^ 15 + C ((122925476389522 / 8639957931 : ℚ)) * X ^ 16 + C ((-26215675780757 / 8639957931 : ℚ)) * X ^ 17 + C ((-109411045334324 / 8639957931 : ℚ)) * X ^ 18
def CV_202_5_pim : Polynomial ℚ := C ((-48778302816520 / 2879985977 : ℚ)) + C ((-97556605633040 / 2879985977 : ℚ)) * X + C ((-8430954869420 / 261816907 : ℚ)) * X ^ 2 + C ((-25271360289058 / 785450721 : ℚ)) * X ^ 3 + C ((-25370875467704 / 2879985977 : ℚ)) * X ^ 4 + C ((236314849659623 / 8639957931 : ℚ)) * X ^ 5 + C ((1309034613910 / 23801537 : ℚ)) * X ^ 6 + C ((780306977174986 / 8639957931 : ℚ)) * X ^ 7 + C ((316287830022820 / 2879985977 : ℚ)) * X ^ 8 + C ((944961005882066 / 8639957931 : ℚ)) * X ^ 9 + C ((928457676808714 / 8639957931 : ℚ)) * X ^ 10 + C ((350099952406440 / 2879985977 : ℚ)) * X ^ 11 + C ((106558367057266 / 785450721 : ℚ)) * X ^ 12 + C ((1141190402348314 / 8639957931 : ℚ)) * X ^ 13 + C ((1137051370650698 / 8639957931 : ℚ)) * X ^ 14 + C ((946113895815038 / 8639957931 : ℚ)) * X ^ 15 + C ((654706151168956 / 8639957931 : ℚ)) * X ^ 16 + C ((147243110620537 / 2879985977 : ℚ)) * X ^ 17 + C ((52540550317536 / 2879985977 : ℚ)) * X ^ 18
theorem CV_202_5_pre_eq :
    CV_2_re_002 * Fplus_dW_re_200 - CV_2_im_002 * Fplus_dW_im_200 = CV_202_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_202_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_5_pim_eq :
    CV_2_re_002 * Fplus_dW_im_200 + CV_2_im_002 * Fplus_dW_re_200 = CV_202_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_202_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_202_5_mul :
    CV_2_c_002 * Fplus_dW_c_200 = ofLadj CV_202_5_pre CV_202_5_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_200_def, ofLadj_mul, CV_202_5_pre_eq, CV_202_5_pim_eq]

@[expose] public def CV_coeff_202 : Ki := CV_0_c_101 * Fplus_dU_c_101 + CV_0_c_002 * Fplus_dU_c_200 + CV_1_c_101 * Fplus_dV_c_101 + CV_1_c_002 * Fplus_dV_c_200 + CV_2_c_101 * Fplus_dW_c_101 + CV_2_c_002 * Fplus_dW_c_200

theorem CV_coeff_202_sum :
    CV_coeff_202 = ofLadj (CV_202_0_pre + CV_202_1_pre + CV_202_2_pre + CV_202_3_pre + CV_202_4_pre + CV_202_5_pre) (CV_202_0_pim + CV_202_1_pim + CV_202_2_pim + CV_202_3_pim + CV_202_4_pim + CV_202_5_pim) := by
  simp only [CV_coeff_202, CV_202_0_mul, CV_202_1_mul, CV_202_2_mul, CV_202_3_mul, CV_202_4_mul, CV_202_5_mul]
  simpa [add_assoc] using ofLadj_add6 CV_202_0_pre CV_202_0_pim CV_202_1_pre CV_202_1_pim CV_202_2_pre CV_202_2_pim CV_202_3_pre CV_202_3_pim CV_202_4_pre CV_202_4_pim CV_202_5_pre CV_202_5_pim

def CV_202_qre : Polynomial ℚ := C ((129982588359043 / 8639957931 : ℚ)) + C ((-22544631458669 / 785450721 : ℚ)) * X + C ((-78703085858569 / 2879985977 : ℚ)) * X ^ 2 + C ((-363352454264738 / 8639957931 : ℚ)) * X ^ 3 + C ((-316561593200803 / 2879985977 : ℚ)) * X ^ 4 + C ((-855063695215765 / 8639957931 : ℚ)) * X ^ 5 + C ((-875255436815819 / 8639957931 : ℚ)) * X ^ 6 + C ((-203343636988356 / 2879985977 : ℚ)) * X ^ 7 + C ((-3184605752610 / 261816907 : ℚ)) * X ^ 8
def CV_202_qim : Polynomial ℚ := C ((180283105136058 / 2879985977 : ℚ)) + C ((180283105136058 / 2879985977 : ℚ)) * X + C ((200163883769030 / 2879985977 : ℚ)) * X ^ 2 + C ((832466988399208 / 8639957931 : ℚ)) * X ^ 3 + C ((42164114314532 / 785450721 : ℚ)) * X ^ 4 + C ((93345134448581 / 8639957931 : ℚ)) * X ^ 5 + C ((-2234864209935 / 261816907 : ℚ)) * X ^ 6 + C ((-663742942226473 / 8639957931 : ℚ)) * X ^ 7 + C ((-394712011756262 / 8639957931 : ℚ)) * X ^ 8
theorem CV_coeff_202_poly_re :
    CV_202_0_pre + CV_202_1_pre + CV_202_2_pre + CV_202_3_pre + CV_202_4_pre + CV_202_5_pre = (0 : Polynomial ℚ) + Phi11 * CV_202_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_202_0_pre, CV_202_1_pre, CV_202_2_pre, CV_202_3_pre, CV_202_4_pre, CV_202_5_pre, CV_202_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_202_poly_im :
    CV_202_0_pim + CV_202_1_pim + CV_202_2_pim + CV_202_3_pim + CV_202_4_pim + CV_202_5_pim = (0 : Polynomial ℚ) + Phi11 * CV_202_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_202_0_pim, CV_202_1_pim, CV_202_2_pim, CV_202_3_pim, CV_202_4_pim, CV_202_5_pim, CV_202_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_202_eq :
    CV_coeff_202 = (0 : Ki) := by
  rw [CV_coeff_202_sum, CV_coeff_202_poly_re,
    CV_coeff_202_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
