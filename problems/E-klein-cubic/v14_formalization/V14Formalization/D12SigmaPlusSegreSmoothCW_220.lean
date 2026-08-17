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

def CW_220_0_pre : Polynomial ℚ := C ((-513950307140 / 8639957931 : ℚ)) + C ((1053398307784 / 2879985977 : ℚ)) * X + C ((1774338640721 / 2879985977 : ℚ)) * X ^ 2 + C ((870240750941 / 785450721 : ℚ)) * X ^ 3 + C ((16867428636151 / 8639957931 : ℚ)) * X ^ 4 + C ((6874190182150 / 2879985977 : ℚ)) * X ^ 5 + C ((2381824249766 / 785450721 : ℚ)) * X ^ 6 + C ((27553968962992 / 8639957931 : ℚ)) * X ^ 7 + C ((25242906419443 / 8639957931 : ℚ)) * X ^ 8 + C ((8074556116254 / 2879985977 : ℚ)) * X ^ 9 + C ((22592208454261 / 8639957931 : ℚ)) * X ^ 10 + C ((7748460623186 / 2879985977 : ℚ)) * X ^ 11 + C ((19432013530909 / 8639957931 : ℚ)) * X ^ 12 + C ((6300217475533 / 2879985977 : ℚ)) * X ^ 13 + C ((5223419386364 / 2879985977 : ℚ)) * X ^ 14 + C ((3308471136068 / 2879985977 : ℚ)) * X ^ 15 + C ((612696933710 / 785450721 : ℚ)) * X ^ 16 + C ((387390023278 / 2879985977 : ℚ)) * X ^ 17 + C ((-253708972879 / 2879985977 : ℚ)) * X ^ 18
def CW_220_0_pim : Polynomial ℚ := C ((-3137741711641 / 8639957931 : ℚ)) + C ((-6275483423282 / 8639957931 : ℚ)) * X + C ((-7545434468302 / 8639957931 : ℚ)) * X ^ 2 + C ((-11518418366573 / 8639957931 : ℚ)) * X ^ 3 + C ((-10623660836707 / 8639957931 : ℚ)) * X ^ 4 + C ((-8481814136722 / 8639957931 : ℚ)) * X ^ 5 + C ((-5781058002301 / 8639957931 : ℚ)) * X ^ 6 + C ((1089455564377 / 8639957931 : ℚ)) * X ^ 7 + C ((293254729265 / 785450721 : ℚ)) * X ^ 8 + C ((1138213236136 / 2879985977 : ℚ)) * X ^ 9 + C ((2247129015752 / 8639957931 : ℚ)) * X ^ 10 + C ((4065708169606 / 8639957931 : ℚ)) * X ^ 11 + C ((1961429107820 / 2879985977 : ℚ)) * X ^ 12 + C ((5986727675824 / 8639957931 : ℚ)) * X ^ 13 + C ((10148549260588 / 8639957931 : ℚ)) * X ^ 14 + C ((3145508234963 / 2879985977 : ℚ)) * X ^ 15 + C ((3006287955733 / 2879985977 : ℚ)) * X ^ 16 + C ((7099941187754 / 8639957931 : ℚ)) * X ^ 17 + C ((59200408587 / 261816907 : ℚ)) * X ^ 18
theorem CW_220_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_110 - CW_0_im_110 * Fplus_dU_im_110 = CW_220_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_110, Fplus_dU_im_110, CW_220_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_110 + CW_0_im_110 * Fplus_dU_re_110 = CW_220_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_110, Fplus_dU_im_110, CW_220_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_0_mul :
    CW_0_c_110 * Fplus_dU_c_110 = ofLadj CW_220_0_pre CW_220_0_pim := by
  rw [CW_0_c_110, Fplus_dU_c_110, ofLadj_mul, CW_220_0_pre_eq, CW_220_0_pim_eq]

def CW_220_1_pre : Polynomial ℚ := C ((608835072255 / 2879985977 : ℚ)) + C ((638605834722 / 2879985977 : ℚ)) * X ^ 2 + C ((168785643853 / 2879985977 : ℚ)) * X ^ 3 + C ((-572628274179 / 2879985977 : ℚ)) * X ^ 4 + C ((-944235220631 / 2879985977 : ℚ)) * X ^ 5 + C ((-1955531843169 / 2879985977 : ℚ)) * X ^ 6 + C ((-2364290651339 / 2879985977 : ℚ)) * X ^ 7 + C ((-2426954517964 / 2879985977 : ℚ)) * X ^ 8 + C ((-2459460272046 / 2879985977 : ℚ)) * X ^ 9 + C ((-2633852252628 / 2879985977 : ℚ)) * X ^ 10 + C ((-3153823867301 / 2879985977 : ℚ)) * X ^ 11 + C ((-2633852252628 / 2879985977 : ℚ)) * X ^ 12 + C ((-3098066106768 / 2879985977 : ℚ)) * X ^ 13 + C ((-235976378347 / 261816907 : ℚ)) * X ^ 14 + C ((-1716190023813 / 2879985977 : ℚ)) * X ^ 15 + C ((-119723486665 / 261816907 : ℚ)) * X ^ 16 + C ((-305661730777 / 2879985977 : ℚ)) * X ^ 17 + C ((75472353347 / 2879985977 : ℚ)) * X ^ 18
def CW_220_1_pim : Polynomial ℚ := C ((553448108679 / 2879985977 : ℚ)) + C ((1106896217358 / 2879985977 : ℚ)) * X + C ((1402867491782 / 2879985977 : ℚ)) * X ^ 2 + C ((245598661224 / 261816907 : ℚ)) * X ^ 3 + C ((2751861795906 / 2879985977 : ℚ)) * X ^ 4 + C ((3394497675697 / 2879985977 : ℚ)) * X ^ 5 + C ((3275580632497 / 2879985977 : ℚ)) * X ^ 6 + C ((2840605953343 / 2879985977 : ℚ)) * X ^ 7 + C ((2720525744502 / 2879985977 : ℚ)) * X ^ 8 + C ((2769308875743 / 2879985977 : ℚ)) * X ^ 9 + C ((2675376875603 / 2879985977 : ℚ)) * X ^ 10 + C ((184482702893 / 261816907 : ℚ)) * X ^ 11 + C ((1383242588043 / 2879985977 : ℚ)) * X ^ 12 + C ((993339313479 / 2879985977 : ℚ)) * X ^ 13 + C ((-256595336962 / 2879985977 : ℚ)) * X ^ 14 + C ((-356395834316 / 2879985977 : ℚ)) * X ^ 15 + C ((-806365173104 / 2879985977 : ℚ)) * X ^ 16 + C ((-63472495826 / 261816907 : ℚ)) * X ^ 17 + C ((-70556233929 / 2879985977 : ℚ)) * X ^ 18
theorem CW_220_1_pre_eq :
    CW_0_re_020 * Fplus_dU_re_200 - CW_0_im_020 * Fplus_dU_im_200 = CW_220_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020, CW_0_im_020, Fplus_dU_re_200, Fplus_dU_im_200, CW_220_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_1_pim_eq :
    CW_0_re_020 * Fplus_dU_im_200 + CW_0_im_020 * Fplus_dU_re_200 = CW_220_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020, CW_0_im_020, Fplus_dU_re_200, Fplus_dU_im_200, CW_220_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_1_mul :
    CW_0_c_020 * Fplus_dU_c_200 = ofLadj CW_220_1_pre CW_220_1_pim := by
  rw [CW_0_c_020, Fplus_dU_c_200, ofLadj_mul, CW_220_1_pre_eq, CW_220_1_pim_eq]

def CW_220_2_pre : Polynomial ℚ := C ((-276963899335 / 2879985977 : ℚ)) + C ((1273036199370 / 2879985977 : ℚ)) * X + C ((5990931830626 / 8639957931 : ℚ)) * X ^ 2 + C ((11425929606353 / 8639957931 : ℚ)) * X ^ 3 + C ((19302154481075 / 8639957931 : ℚ)) * X ^ 4 + C ((23794453988119 / 8639957931 : ℚ)) * X ^ 5 + C ((30560368142206 / 8639957931 : ℚ)) * X ^ 6 + C ((34158826077863 / 8639957931 : ℚ)) * X ^ 7 + C ((34853409366299 / 8639957931 : ℚ)) * X ^ 8 + C ((35679972419932 / 8639957931 : ℚ)) * X ^ 9 + C ((37273125079592 / 8639957931 : ℚ)) * X ^ 10 + C ((12627216505726 / 2879985977 : ℚ)) * X ^ 11 + C ((33454016481482 / 8639957931 : ℚ)) * X ^ 12 + C ((9896346863102 / 2879985977 : ℚ)) * X ^ 13 + C ((7809159919982 / 2879985977 : ℚ)) * X ^ 14 + C ((4700559405464 / 2879985977 : ℚ)) * X ^ 15 + C ((3049355864411 / 2879985977 : ℚ)) * X ^ 16 + C ((794051146382 / 2879985977 : ℚ)) * X ^ 17 + C ((-251664460132 / 2879985977 : ℚ)) * X ^ 18
def CW_220_2_pim : Polynomial ℚ := C ((-1257146342752 / 2879985977 : ℚ)) + C ((-2514292685504 / 2879985977 : ℚ)) * X + C ((-3065055885638 / 2879985977 : ℚ)) * X ^ 2 + C ((-14557088329657 / 8639957931 : ℚ)) * X ^ 3 + C ((-13681141167970 / 8639957931 : ℚ)) * X ^ 4 + C ((-1222280305352 / 785450721 : ℚ)) * X ^ 5 + C ((-1073088028951 / 785450721 : ℚ)) * X ^ 6 + C ((-2469085871394 / 2879985977 : ℚ)) * X ^ 7 + C ((-4587142557545 / 8639957931 : ℚ)) * X ^ 8 + C ((-1614444160795 / 2879985977 : ℚ)) * X ^ 9 + C ((-3712709342227 / 8639957931 : ℚ)) * X ^ 10 + C ((1220233643978 / 8639957931 : ℚ)) * X ^ 11 + C ((50852699423 / 71404611 : ℚ)) * X ^ 12 + C ((8936089370743 / 8639957931 : ℚ)) * X ^ 13 + C ((14041820118646 / 8639957931 : ℚ)) * X ^ 14 + C ((4352329330238 / 2879985977 : ℚ)) * X ^ 15 + C ((1014990182099 / 785450721 : ℚ)) * X ^ 16 + C ((2993916301896 / 2879985977 : ℚ)) * X ^ 17 + C ((2929000022882 / 8639957931 : ℚ)) * X ^ 18
theorem CW_220_2_pre_eq :
    CW_1_re_110 * Fplus_dV_re_110 - CW_1_im_110 * Fplus_dV_im_110 = CW_220_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_110, Fplus_dV_im_110, CW_220_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_2_pim_eq :
    CW_1_re_110 * Fplus_dV_im_110 + CW_1_im_110 * Fplus_dV_re_110 = CW_220_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_110, Fplus_dV_im_110, CW_220_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_2_mul :
    CW_1_c_110 * Fplus_dV_c_110 = ofLadj CW_220_2_pre CW_220_2_pim := by
  rw [CW_1_c_110, Fplus_dV_c_110, ofLadj_mul, CW_220_2_pre_eq, CW_220_2_pim_eq]

def CW_220_3_pre : Polynomial ℚ := C ((370433125919 / 8639957931 : ℚ)) + C ((-477290527184 / 8639957931 : ℚ)) * X + C ((-349625349092 / 8639957931 : ℚ)) * X ^ 2 + C ((-1212353614243 / 8639957931 : ℚ)) * X ^ 3 + C ((-2456258546333 / 8639957931 : ℚ)) * X ^ 4 + C ((-2453650230802 / 8639957931 : ℚ)) * X ^ 5 + C ((-3953253628402 / 8639957931 : ℚ)) * X ^ 6 + C ((-1282594225799 / 2879985977 : ℚ)) * X ^ 7 + C ((-3221158620727 / 8639957931 : ℚ)) * X ^ 8 + C ((-3252773301376 / 8639957931 : ℚ)) * X ^ 9 + C ((-2743907264641 / 8639957931 : ℚ)) * X ^ 10 + C ((-3440376450554 / 8639957931 : ℚ)) * X ^ 11 + C ((-2266616737457 / 8639957931 : ℚ)) * X ^ 12 + C ((-2903147952284 / 8639957931 : ℚ)) * X ^ 13 + C ((-669601668828 / 2879985977 : ℚ)) * X ^ 14 + C ((-106411263065 / 785450721 : ℚ)) * X ^ 15 + C ((-105551960735 / 785450721 : ℚ)) * X ^ 16 + C ((2797783715 / 71404611 : ℚ)) * X ^ 17 + C ((73666745783 / 2879985977 : ℚ)) * X ^ 18
def CW_220_3_pim : Polynomial ℚ := C ((185853142592 / 2879985977 : ℚ)) + C ((371706285184 / 2879985977 : ℚ)) * X + C ((1111378408216 / 8639957931 : ℚ)) * X ^ 2 + C ((6290773202 / 23801537 : ℚ)) * X ^ 3 + C ((1577654791714 / 8639957931 : ℚ)) * X ^ 4 + C ((1627399148158 / 8639957931 : ℚ)) * X ^ 5 + C ((478045196859 / 2879985977 : ℚ)) * X ^ 6 + C ((-215373204439 / 8639957931 : ℚ)) * X ^ 7 + C ((-6240860185 / 2879985977 : ℚ)) * X ^ 8 + C ((-231104927096 / 8639957931 : ℚ)) * X ^ 9 + C ((26192427226 / 2879985977 : ℚ)) * X ^ 10 + C ((-104542990720 / 2879985977 : ℚ)) * X ^ 11 + C ((-235278408666 / 2879985977 : ℚ)) * X ^ 12 + C ((-392412569888 / 8639957931 : ℚ)) * X ^ 13 + C ((-592322393513 / 2879985977 : ℚ)) * X ^ 14 + C ((-289252445457 / 2879985977 : ℚ)) * X ^ 15 + C ((-490047679405 / 2879985977 : ℚ)) * X ^ 16 + C ((-1103530789288 / 8639957931 : ℚ)) * X ^ 17 + C ((-201919384 / 261816907 : ℚ)) * X ^ 18
theorem CW_220_3_pre_eq :
    CW_1_re_020 * Fplus_dV_re_200 - CW_1_im_020 * Fplus_dV_im_200 = CW_220_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020, CW_1_im_020, Fplus_dV_re_200, Fplus_dV_im_200, CW_220_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_3_pim_eq :
    CW_1_re_020 * Fplus_dV_im_200 + CW_1_im_020 * Fplus_dV_re_200 = CW_220_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020, CW_1_im_020, Fplus_dV_re_200, Fplus_dV_im_200, CW_220_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_3_mul :
    CW_1_c_020 * Fplus_dV_c_200 = ofLadj CW_220_3_pre CW_220_3_pim := by
  rw [CW_1_c_020, Fplus_dV_c_200, ofLadj_mul, CW_220_3_pre_eq, CW_220_3_pim_eq]

def CW_220_4_pre : Polynomial ℚ := C ((-6654237556 / 32359393 : ℚ)) + C ((-3182147440 / 32359393 : ℚ)) * X + C ((-41503857334 / 97078179 : ℚ)) * X ^ 2 + C ((-143867006 / 267433 : ℚ)) * X ^ 3 + C ((-5589584567 / 8825289 : ℚ)) * X ^ 4 + C ((-33753958848 / 32359393 : ℚ)) * X ^ 5 + C ((-84765839783 / 97078179 : ℚ)) * X ^ 6 + C ((-105992692691 / 97078179 : ℚ)) * X ^ 7 + C ((-103749727105 / 97078179 : ℚ)) * X ^ 8 + C ((-102726243317 / 97078179 : ℚ)) * X ^ 9 + C ((-101154420904 / 97078179 : ℚ)) * X ^ 10 + C ((-27411456338 / 32359393 : ℚ)) * X ^ 11 + C ((-91607978584 / 97078179 : ℚ)) * X ^ 12 + C ((-5565671453 / 8825289 : ℚ)) * X ^ 13 + C ((-51526003927 / 97078179 : ℚ)) * X ^ 14 + C ((-4009974160 / 8825289 : ℚ)) * X ^ 15 + C ((-4688697767 / 97078179 : ℚ)) * X ^ 16 + C ((-7061578176 / 32359393 : ℚ)) * X ^ 17 + C ((397546694 / 97078179 : ℚ)) * X ^ 18
def CW_220_4_pim : Polynomial ℚ := C ((-531836826 / 32359393 : ℚ)) + C ((-1063673652 / 32359393 : ℚ)) * X + C ((14267626556 / 97078179 : ℚ)) * X ^ 2 + C ((-16249895320 / 97078179 : ℚ)) * X ^ 3 + C ((2257640571 / 32359393 : ℚ)) * X ^ 4 + C ((-24315260924 / 97078179 : ℚ)) * X ^ 5 + C ((-13000515797 / 32359393 : ℚ)) * X ^ 6 + C ((-41979821207 / 97078179 : ℚ)) * X ^ 7 + C ((-61280223877 / 97078179 : ℚ)) * X ^ 8 + C ((-61443961540 / 97078179 : ℚ)) * X ^ 9 + C ((-20094987062 / 32359393 : ℚ)) * X ^ 10 + C ((-57567867956 / 97078179 : ℚ)) * X ^ 11 + C ((-4986434066 / 8825289 : ℚ)) * X ^ 12 + C ((-71150421884 / 97078179 : ℚ)) * X ^ 13 + C ((-40796637671 / 97078179 : ℚ)) * X ^ 14 + C ((-5771540344 / 8825289 : ℚ)) * X ^ 15 + C ((-11538162395 / 32359393 : ℚ)) * X ^ 16 + C ((-20395461368 / 97078179 : ℚ)) * X ^ 17 + C ((-6544304530 / 32359393 : ℚ)) * X ^ 18
theorem CW_220_4_pre_eq :
    CW_2_re_110 * Fplus_dW_re_110 - CW_2_im_110 * Fplus_dW_im_110 = CW_220_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_110, Fplus_dW_im_110, CW_220_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_4_pim_eq :
    CW_2_re_110 * Fplus_dW_im_110 + CW_2_im_110 * Fplus_dW_re_110 = CW_220_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_110, Fplus_dW_im_110, CW_220_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_4_mul :
    CW_2_c_110 * Fplus_dW_c_110 = ofLadj CW_220_4_pre CW_220_4_pim := by
  rw [CW_2_c_110, Fplus_dW_c_110, ofLadj_mul, CW_220_4_pre_eq, CW_220_4_pim_eq]

def CW_220_5_pre : Polynomial ℚ := C ((-1749167551060 / 8639957931 : ℚ)) + C ((-58201967104 / 8639957931 : ℚ)) * X + C ((-2864058148630 / 8639957931 : ℚ)) * X ^ 2 + C ((-5011989619192 / 8639957931 : ℚ)) * X ^ 3 + C ((-3700133593028 / 8639957931 : ℚ)) * X ^ 4 + C ((-8062868149126 / 8639957931 : ℚ)) * X ^ 5 + C ((-5408527025338 / 8639957931 : ℚ)) * X ^ 6 + C ((-8021706528865 / 8639957931 : ℚ)) * X ^ 7 + C ((-6432540082598 / 8639957931 : ℚ)) * X ^ 8 + C ((-6201823179787 / 8639957931 : ℚ)) * X ^ 9 + C ((-6289098234692 / 8639957931 : ℚ)) * X ^ 10 + C ((-4304544034880 / 8639957931 : ℚ)) * X ^ 11 + C ((-6230896267588 / 8639957931 : ℚ)) * X ^ 12 + C ((-1112588343719 / 2879985977 : ℚ)) * X ^ 13 + C ((-1420550463406 / 8639957931 : ℚ)) * X ^ 14 + C ((-892436001619 / 2879985977 : ℚ)) * X ^ 15 + C ((504680400366 / 2879985977 : ℚ)) * X ^ 16 + C ((-380099974230 / 2879985977 : ℚ)) * X ^ 17 + C ((1644264930980 / 8639957931 : ℚ)) * X ^ 18
def CW_220_5_pim : Polynomial ℚ := C ((-1134585635192 / 8639957931 : ℚ)) + C ((-2269171270384 / 8639957931 : ℚ)) * X + C ((521962235966 / 8639957931 : ℚ)) * X ^ 2 + C ((-1562463186963 / 2879985977 : ℚ)) * X ^ 3 + C ((-2962410875846 / 8639957931 : ℚ)) * X ^ 4 + C ((-5958267163825 / 8639957931 : ℚ)) * X ^ 5 + C ((-8130310628228 / 8639957931 : ℚ)) * X ^ 6 + C ((-8639070318995 / 8639957931 : ℚ)) * X ^ 7 + C ((-11468940565933 / 8639957931 : ℚ)) * X ^ 8 + C ((-3773660907587 / 2879985977 : ℚ)) * X ^ 9 + C ((-11415132410123 / 8639957931 : ℚ)) * X ^ 10 + C ((-3370068369552 / 2879985977 : ℚ)) * X ^ 11 + C ((-8805277807189 / 8639957931 : ℚ)) * X ^ 12 + C ((-3896853666967 / 2879985977 : ℚ)) * X ^ 13 + C ((-2111083786958 / 2879985977 : ℚ)) * X ^ 14 + C ((-2738804521513 / 2879985977 : ℚ)) * X ^ 15 + C ((-5116863620555 / 8639957931 : ℚ)) * X ^ 16 + C ((-3284140075088 / 8639957931 : ℚ)) * X ^ 17 + C ((-890562242772 / 2879985977 : ℚ)) * X ^ 18
theorem CW_220_5_pre_eq :
    CW_2_re_020 * Fplus_dW_re_200 - CW_2_im_020 * Fplus_dW_im_200 = CW_220_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020, CW_2_im_020, Fplus_dW_re_200, Fplus_dW_im_200, CW_220_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_5_pim_eq :
    CW_2_re_020 * Fplus_dW_im_200 + CW_2_im_020 * Fplus_dW_re_200 = CW_220_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020, CW_2_im_020, Fplus_dW_re_200, Fplus_dW_im_200, CW_220_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_220_5_mul :
    CW_2_c_020 * Fplus_dW_c_200 = ofLadj CW_220_5_pre CW_220_5_pim := by
  rw [CW_2_c_020, Fplus_dW_c_200, ofLadj_mul, CW_220_5_pre_eq, CW_220_5_pim_eq]

@[expose] public def CW_coeff_220 : Ki := CW_0_c_110 * Fplus_dU_c_110 + CW_0_c_020 * Fplus_dU_c_200 + CW_1_c_110 * Fplus_dV_c_110 + CW_1_c_020 * Fplus_dV_c_200 + CW_2_c_110 * Fplus_dW_c_110 + CW_2_c_020 * Fplus_dW_c_200

theorem CW_coeff_220_sum :
    CW_coeff_220 = ofLadj (CW_220_0_pre + CW_220_1_pre + CW_220_2_pre + CW_220_3_pre + CW_220_4_pre + CW_220_5_pre) (CW_220_0_pim + CW_220_1_pim + CW_220_2_pim + CW_220_3_pim + CW_220_4_pim + CW_220_5_pim) := by
  simp only [CW_coeff_220, CW_220_0_mul, CW_220_1_mul, CW_220_2_mul, CW_220_3_mul, CW_220_4_mul, CW_220_5_mul]
  simpa [add_assoc] using ofLadj_add6 CW_220_0_pre CW_220_0_pim CW_220_1_pre CW_220_1_pim CW_220_2_pre CW_220_2_pim CW_220_3_pre CW_220_3_pim CW_220_4_pre CW_220_4_pim CW_220_5_pre CW_220_5_pim

def CW_220_qre : Polynomial ℚ := C ((-2673752640973 / 8639957931 : ℚ)) + C ((8267930301667 / 8639957931 : ℚ)) * X + C ((728060795813 / 8639957931 : ℚ)) * X ^ 2 + C ((4310441745479 / 8639957931 : ℚ)) * X ^ 3 + C ((12190422662249 / 8639957931 : ℚ)) * X ^ 4 + C ((-767609383903 / 8639957931 : ℚ)) * X ^ 5 + C ((3977468495122 / 2879985977 : ℚ)) * X ^ 6 + C ((-670814734621 / 8639957931 : ℚ)) * X ^ 7 + C ((203647861701 / 2879985977 : ℚ)) * X ^ 8
def CW_220_qim : Polynomial ℚ := C ((-1989287684606 / 2879985977 : ℚ)) + C ((-1989287684606 / 2879985977 : ℚ)) * X + C ((768961955144 / 2879985977 : ℚ)) * X ^ 2 + C ((-12191990205677 / 8639957931 : ℚ)) * X ^ 3 + C ((4989647779247 / 8639957931 : ℚ)) * X ^ 4 + C ((-469049345924 / 2879985977 : ℚ)) * X ^ 5 + C ((312733527685 / 8639957931 : ℚ)) * X ^ 6 + C ((7538965378088 / 8639957931 : ℚ)) * X ^ 7 + C ((245265426968 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_220_poly_re :
    CW_220_0_pre + CW_220_1_pre + CW_220_2_pre + CW_220_3_pre + CW_220_4_pre + CW_220_5_pre = (0 : Polynomial ℚ) + Phi11 * CW_220_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_220_0_pre, CW_220_1_pre, CW_220_2_pre, CW_220_3_pre, CW_220_4_pre, CW_220_5_pre, CW_220_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_220_poly_im :
    CW_220_0_pim + CW_220_1_pim + CW_220_2_pim + CW_220_3_pim + CW_220_4_pim + CW_220_5_pim = (0 : Polynomial ℚ) + Phi11 * CW_220_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_220_0_pim, CW_220_1_pim, CW_220_2_pim, CW_220_3_pim, CW_220_4_pim, CW_220_5_pim, CW_220_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CW_coeff_220_eq :
    CW_coeff_220 = (0 : Ki) := by
  rw [CW_coeff_220_sum, CW_coeff_220_poly_re,
    CW_coeff_220_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
