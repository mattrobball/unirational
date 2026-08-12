/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreMul
import V14Formalization.D12SigmaPlusSegrePartials
import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CV_102_0_pre : Polynomial ℚ := C ((138921579883 / 8639957931 : ℚ)) + C ((6702217511332 / 8639957931 : ℚ)) * X + C ((1169941116244 / 785450721 : ℚ)) * X ^ 2 + C ((21018776238352 / 8639957931 : ℚ)) * X ^ 3 + C ((10815298421036 / 2879985977 : ℚ)) * X ^ 4 + C ((78007344912527 / 17279915862 : ℚ)) * X ^ 5 + C ((45357718866964 / 8639957931 : ℚ)) * X ^ 6 + C ((49181932187722 / 8639957931 : ℚ)) * X ^ 7 + C ((16126211630296 / 2879985977 : ℚ)) * X ^ 8 + C ((2971590243977 / 523633814 : ℚ)) * X ^ 9 + C ((49516550579680 / 8639957931 : ℚ)) * X ^ 10 + C ((49572842735194 / 8639957931 : ℚ)) * X ^ 11 + C ((14271444356116 / 2879985977 : ℚ)) * X ^ 12 + C ((597717136313 / 142809222 : ℚ)) * X ^ 13 + C ((27359858652536 / 8639957931 : ℚ)) * X ^ 14 + C ((5108392977957 / 2879985977 : ℚ)) * X ^ 15 + C ((8383813783505 / 8639957931 : ℚ)) * X ^ 16 + C ((4059534745609 / 17279915862 : ℚ)) * X ^ 17 + C ((-1410857990743 / 8639957931 : ℚ)) * X ^ 18
def CV_102_0_pim : Polynomial ℚ := C ((-1635382607189 / 2879985977 : ℚ)) + C ((-3270765214378 / 2879985977 : ℚ)) * X + C ((-11600450308165 / 8639957931 : ℚ)) * X ^ 2 + C ((-5036017042926 / 2879985977 : ℚ)) * X ^ 3 + C ((-4350579682058 / 2879985977 : ℚ)) * X ^ 4 + C ((-16251231525569 / 17279915862 : ℚ)) * X ^ 5 + C ((-4320828098534 / 8639957931 : ℚ)) * X ^ 6 + C ((880174597417 / 2879985977 : ℚ)) * X ^ 7 + C ((6307759815215 / 8639957931 : ℚ)) * X ^ 8 + C ((12871508626387 / 17279915862 : ℚ)) * X ^ 9 + C ((6848868776518 / 8639957931 : ℚ)) * X ^ 10 + C ((12394466492834 / 8639957931 : ℚ)) * X ^ 11 + C ((5980021403050 / 2879985977 : ℚ)) * X ^ 12 + C ((13427555558337 / 5759971954 : ℚ)) * X ^ 13 + C ((23776928656097 / 8639957931 : ℚ)) * X ^ 14 + C ((21426188759270 / 8639957931 : ℚ)) * X ^ 15 + C ((179518330724 / 97078179 : ℚ)) * X ^ 16 + C ((7630633179611 / 5759971954 : ℚ)) * X ^ 17 + C ((3961663837187 / 8639957931 : ℚ)) * X ^ 18
theorem CV_102_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_002 - CV_0_im_100 * Fplus_dU_im_002 = CV_102_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100, CV_0_im_100, Fplus_dU_re_002, Fplus_dU_im_002, CV_102_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_002 + CV_0_im_100 * Fplus_dU_re_002 = CV_102_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100, CV_0_im_100, Fplus_dU_re_002, Fplus_dU_im_002, CV_102_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_0_mul :
    CV_0_c_100 * Fplus_dU_c_002 = ofLadj CV_102_0_pre CV_102_0_pim := by
  rw [CV_0_c_100, Fplus_dU_c_002, ofLadj_mul, CV_102_0_pre_eq, CV_102_0_pim_eq]

def CV_102_1_pre : Polynomial ℚ := C ((-20224547767816 / 785450721 : ℚ)) + C ((-1587353211088640 / 8639957931 : ℚ)) * X + C ((-2992895094763064 / 8639957931 : ℚ)) * X ^ 2 + C ((-1569035326906940 / 2879985977 : ℚ)) * X ^ 3 + C ((-2233646893107980 / 2879985977 : ℚ)) * X ^ 4 + C ((-2560178336306057 / 2879985977 : ℚ)) * X ^ 5 + C ((-8409182514954949 / 8639957931 : ℚ)) * X ^ 6 + C ((-8746583834569604 / 8639957931 : ℚ)) * X ^ 7 + C ((-245546492869567 / 261816907 : ℚ)) * X ^ 8 + C ((-7979881314289003 / 8639957931 : ℚ)) * X ^ 9 + C ((-2628835097719728 / 2879985977 : ℚ)) * X ^ 10 + C ((-2542866606597340 / 2879985977 : ℚ)) * X ^ 11 + C ((-6299152082070544 / 8639957931 : ℚ)) * X ^ 12 + C ((-4986986219525939 / 8639957931 : ℚ)) * X ^ 13 + C ((-1131976094658297 / 2879985977 : ℚ)) * X ^ 14 + C ((-137700988451024 / 785450721 : ℚ)) * X ^ 15 + C ((-602335095016081 / 8639957931 : ℚ)) * X ^ 16 + C ((3827648818809 / 261816907 : ℚ)) * X ^ 17 + C ((530932282284400 / 8639957931 : ℚ)) * X ^ 18
def CV_102_1_pim : Polynomial ℚ := C ((711502972375696 / 8639957931 : ℚ)) + C ((1423005944751392 / 8639957931 : ℚ)) * X + C ((1353842271307976 / 8639957931 : ℚ)) * X ^ 2 + C ((1349008937725670 / 8639957931 : ℚ)) * X ^ 3 + C ((365838955049300 / 8639957931 : ℚ)) * X ^ 4 + C ((-35041855601293 / 261816907 : ℚ)) * X ^ 5 + C ((-2322958401695867 / 8639957931 : ℚ)) * X ^ 6 + C ((-3808755559328162 / 8639957931 : ℚ)) * X ^ 7 + C ((-4631661644391377 / 8639957931 : ℚ)) * X ^ 8 + C ((-1538117534224101 / 2879985977 : ℚ)) * X ^ 9 + C ((-4532901424699918 / 8639957931 : ℚ)) * X ^ 10 + C ((-5125393200164960 / 8639957931 : ℚ)) * X ^ 11 + C ((-1905961658543334 / 2879985977 : ℚ)) * X ^ 12 + C ((-5567270124214201 / 8639957931 : ℚ)) * X ^ 13 + C ((-5545127748912821 / 8639957931 : ℚ)) * X ^ 14 + C ((-1537694831649178 / 2879985977 : ℚ)) * X ^ 15 + C ((-3195704440944035 / 8639957931 : ℚ)) * X ^ 16 + C ((-2152736378095957 / 8639957931 : ℚ)) * X ^ 17 + C ((-771779356352132 / 8639957931 : ℚ)) * X ^ 18
theorem CV_102_1_pre_eq :
    CV_0_re_001 * Fplus_dU_re_101 - CV_0_im_001 * Fplus_dU_im_101 = CV_102_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001, CV_0_im_001, Fplus_dU_re_101, Fplus_dU_im_101, CV_102_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_1_pim_eq :
    CV_0_re_001 * Fplus_dU_im_101 + CV_0_im_001 * Fplus_dU_re_101 = CV_102_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001, CV_0_im_001, Fplus_dU_re_101, Fplus_dU_im_101, CV_102_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_1_mul :
    CV_0_c_001 * Fplus_dU_c_101 = ofLadj CV_102_1_pre CV_102_1_pim := by
  rw [CV_0_c_001, Fplus_dU_c_101, ofLadj_mul, CV_102_1_pre_eq, CV_102_1_pim_eq]

def CV_102_2_pre : Polynomial ℚ := C ((-2408997440 / 97078179 : ℚ)) + C ((1309153810000 / 2879985977 : ℚ)) * X + C ((8343424555363 / 8639957931 : ℚ)) * X ^ 2 + C ((28584606633259 / 17279915862 : ℚ)) * X ^ 3 + C ((45513274620103 / 17279915862 : ℚ)) * X ^ 4 + C ((29414964057148 / 8639957931 : ℚ)) * X ^ 5 + C ((69375303296501 / 17279915862 : ℚ)) * X ^ 6 + C ((36222623192900 / 8639957931 : ℚ)) * X ^ 7 + C ((32722256927287 / 8639957931 : ℚ)) * X ^ 8 + C ((10084707237169 / 2879985977 : ℚ)) * X ^ 9 + C ((28412671489969 / 8639957931 : ℚ)) * X ^ 10 + C ((27925610189945 / 8639957931 : ℚ)) * X ^ 11 + C ((24485210059969 / 8639957931 : ℚ)) * X ^ 12 + C ((246187608496 / 97078179 : ℚ)) * X ^ 13 + C ((36859907221315 / 17279915862 : ℚ)) * X ^ 14 + C ((8150761863947 / 5759971954 : ℚ)) * X ^ 15 + C ((13839660261443 / 17279915862 : ℚ)) * X ^ 16 + C ((1647142539619 / 8639957931 : ℚ)) * X ^ 17 + C ((-413281028976 / 2879985977 : ℚ)) * X ^ 18
def CV_102_2_pim : Polynomial ℚ := C ((-384229814765 / 785450721 : ℚ)) + C ((-768459629530 / 785450721 : ℚ)) * X + C ((-10446221437243 / 8639957931 : ℚ)) * X ^ 2 + C ((-26588264960651 / 17279915862 : ℚ)) * X ^ 3 + C ((-25986189443615 / 17279915862 : ℚ)) * X ^ 4 + C ((-3067906446524 / 2879985977 : ℚ)) * X ^ 5 + C ((-7879244577745 / 17279915862 : ℚ)) * X ^ 6 + C ((3359165446550 / 8639957931 : ℚ)) * X ^ 7 + C ((2452609607214 / 2879985977 : ℚ)) * X ^ 8 + C ((2327213157619 / 2879985977 : ℚ)) * X ^ 9 + C ((1784558973359 / 2879985977 : ℚ)) * X ^ 10 + C ((2405822176412 / 2879985977 : ℚ)) * X ^ 11 + C ((3027085379465 / 2879985977 : ℚ)) * X ^ 12 + C ((9446459098028 / 8639957931 : ℚ)) * X ^ 13 + C ((2166941962241 / 1570901442 : ℚ)) * X ^ 14 + C ((25297538034767 / 17279915862 : ℚ)) * X ^ 15 + C ((7296872891915 / 5759971954 : ℚ)) * X ^ 16 + C ((247876043158 / 261816907 : ℚ)) * X ^ 17 + C ((269730671956 / 785450721 : ℚ)) * X ^ 18
theorem CV_102_2_pre_eq :
    CV_1_re_100 * Fplus_dV_re_002 - CV_1_im_100 * Fplus_dV_im_002 = CV_102_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100, CV_1_im_100, Fplus_dV_re_002, Fplus_dV_im_002, CV_102_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_2_pim_eq :
    CV_1_re_100 * Fplus_dV_im_002 + CV_1_im_100 * Fplus_dV_re_002 = CV_102_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100, CV_1_im_100, Fplus_dV_re_002, Fplus_dV_im_002, CV_102_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_2_mul :
    CV_1_c_100 * Fplus_dV_c_002 = ofLadj CV_102_2_pre CV_102_2_pim := by
  rw [CV_1_c_100, Fplus_dV_c_002, ofLadj_mul, CV_102_2_pre_eq, CV_102_2_pim_eq]

def CV_102_3_pre : Polynomial ℚ := C ((112959577259084 / 8639957931 : ℚ)) + C ((1558125535813040 / 8639957931 : ℚ)) * X + C ((3168218808795310 / 8639957931 : ℚ)) * X ^ 2 + C ((43053672213566 / 71404611 : ℚ)) * X ^ 3 + C ((2585570505358606 / 2879985977 : ℚ)) * X ^ 4 + C ((9217775369556934 / 8639957931 : ℚ)) * X ^ 5 + C ((3464728451189854 / 2879985977 : ℚ)) * X ^ 6 + C ((3680105907752136 / 2879985977 : ℚ)) * X ^ 7 + C ((10516807472308483 / 8639957931 : ℚ)) * X ^ 8 + C ((3439175913556396 / 2879985977 : ℚ)) * X ^ 9 + C ((308063821082857 / 261816907 : ℚ)) * X ^ 10 + C ((9996068925850120 / 8639957931 : ℚ)) * X ^ 11 + C ((8607980559921241 / 8639957931 : ℚ)) * X ^ 12 + C ((649937175624898 / 785450721 : ℚ)) * X ^ 13 + C ((5307313134466997 / 8639957931 : ℚ)) * X ^ 14 + C ((2942660145991520 / 8639957931 : ℚ)) * X ^ 15 + C ((48193898741148 / 261816907 : ℚ)) * X ^ 16 + C ((413988674445256 / 8639957931 : ℚ)) * X ^ 17 + C ((-340946061189070 / 8639957931 : ℚ)) * X ^ 18
def CV_102_3_pim : Polynomial ℚ := C ((-95464870388824 / 785450721 : ℚ)) + C ((-190929740777648 / 785450721 : ℚ)) * X + C ((-20589270540914 / 71404611 : ℚ)) * X ^ 2 + C ((-266838297236176 / 785450721 : ℚ)) * X ^ 3 + C ((-2209101816676780 / 8639957931 : ℚ)) * X ^ 4 + C ((-769765705298948 / 8639957931 : ℚ)) * X ^ 5 + C ((380716624828202 / 8639957931 : ℚ)) * X ^ 6 + C ((2075782691628428 / 8639957931 : ℚ)) * X ^ 7 + C ((3045493941119989 / 8639957931 : ℚ)) * X ^ 8 + C ((3017180020359886 / 8639957931 : ℚ)) * X ^ 9 + C ((961789937641721 / 2879985977 : ℚ)) * X ^ 10 + C ((1247582297826204 / 2879985977 : ℚ)) * X ^ 11 + C ((1533374658010687 / 2879985977 : ℚ)) * X ^ 12 + C ((1619796117831268 / 2879985977 : ℚ)) * X ^ 13 + C ((1758331322293681 / 2879985977 : ℚ)) * X ^ 14 + C ((1543985102744618 / 2879985977 : ℚ)) * X ^ 15 + C ((1120713953945748 / 2879985977 : ℚ)) * X ^ 16 + C ((2412173857036598 / 8639957931 : ℚ)) * X ^ 17 + C ((886630455217594 / 8639957931 : ℚ)) * X ^ 18
theorem CV_102_3_pre_eq :
    CV_1_re_001 * Fplus_dV_re_101 - CV_1_im_001 * Fplus_dV_im_101 = CV_102_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001, CV_1_im_001, Fplus_dV_re_101, Fplus_dV_im_101, CV_102_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_3_pim_eq :
    CV_1_re_001 * Fplus_dV_im_101 + CV_1_im_001 * Fplus_dV_re_101 = CV_102_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001, CV_1_im_001, Fplus_dV_re_101, Fplus_dV_im_101, CV_102_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_3_mul :
    CV_1_c_001 * Fplus_dV_c_101 = ofLadj CV_102_3_pre CV_102_3_pim := by
  rw [CV_1_c_001, Fplus_dV_c_101, ofLadj_mul, CV_102_3_pre_eq, CV_102_3_pim_eq]

def CV_102_4_pre : Polynomial ℚ := C ((-375045563011 / 2879985977 : ℚ)) + C ((1977210772569 / 5759971954 : ℚ)) * X ^ 2 + C ((2279798685170 / 2879985977 : ℚ)) * X ^ 3 + C ((3462115493026 / 2879985977 : ℚ)) * X ^ 4 + C ((4169661452073 / 2879985977 : ℚ)) * X ^ 5 + C ((4169661452073 / 2879985977 : ℚ)) * X ^ 6 + C ((3462115493026 / 2879985977 : ℚ)) * X ^ 7 + C ((2279798685170 / 2879985977 : ℚ)) * X ^ 8 + C ((1977210772569 / 5759971954 : ℚ)) * X ^ 9
def CV_102_4_pim : Polynomial ℚ := C ((-1260096205107 / 2879985977 : ℚ)) + C ((-2520192410214 / 2879985977 : ℚ)) * X + C ((-6731382987343 / 5759971954 : ℚ)) * X ^ 2 + C ((-3553957665240 / 2879985977 : ℚ)) * X ^ 3 + C ((-3002276964011 / 2879985977 : ℚ)) * X ^ 4 + C ((-15858016455 / 23801537 : ℚ)) * X ^ 5 + C ((-601372419159 / 2879985977 : ℚ)) * X ^ 6 + C ((43825868527 / 261816907 : ℚ)) * X ^ 7 + C ((1033765255026 / 2879985977 : ℚ)) * X ^ 8 + C ((1690998166915 / 5759971954 : ℚ)) * X ^ 9
theorem CV_102_4_pre_eq :
    CV_2_re_100 * Fplus_dW_re_002 - CV_2_im_100 * Fplus_dW_im_002 = CV_102_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100, CV_2_im_100, Fplus_dW_re_002, Fplus_dW_im_002, CV_102_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_4_pim_eq :
    CV_2_re_100 * Fplus_dW_im_002 + CV_2_im_100 * Fplus_dW_re_002 = CV_102_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100, CV_2_im_100, Fplus_dW_re_002, Fplus_dW_im_002, CV_102_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_4_mul :
    CV_2_c_100 * Fplus_dW_c_002 = ofLadj CV_102_4_pre CV_102_4_pim := by
  rw [CV_2_c_100, Fplus_dW_c_002, ofLadj_mul, CV_102_4_pre_eq, CV_102_4_pim_eq]

def CV_102_5_pre : Polynomial ℚ := C ((18358179884490 / 2879985977 : ℚ)) + C ((302656068583512 / 2879985977 : ℚ)) * X + C ((54908074020788 / 261816907 : ℚ)) * X ^ 2 + C ((2943489761678452 / 8639957931 : ℚ)) * X ^ 3 + C ((4472785044540878 / 8639957931 : ℚ)) * X ^ 4 + C ((5405684605596895 / 8639957931 : ℚ)) * X ^ 5 + C ((6259568903171527 / 8639957931 : ℚ)) * X ^ 6 + C ((6826622180803658 / 8639957931 : ℚ)) * X ^ 7 + C ((6711705530096210 / 8639957931 : ℚ)) * X ^ 8 + C ((6801913150075475 / 8639957931 : ℚ)) * X ^ 9 + C ((6870657609538403 / 8639957931 : ℚ)) * X ^ 10 + C ((6841297017004448 / 8639957931 : ℚ)) * X ^ 11 + C ((5962689403787867 / 8639957931 : ℚ)) * X ^ 12 + C ((4989946707389471 / 8639957931 : ℚ)) * X ^ 13 + C ((3768215768417758 / 8639957931 : ℚ)) * X ^ 14 + C ((2156145313507238 / 8639957931 : ℚ)) * X ^ 15 + C ((391341760375025 / 2879985977 : ℚ)) * X ^ 16 + C ((881931084161 / 23801537 : ℚ)) * X ^ 17 + C ((-197691822755542 / 8639957931 : ℚ)) * X ^ 18
def CV_102_5_pim : Polynomial ℚ := C ((-650550656692202 / 8639957931 : ℚ)) + C ((-1301101313384404 / 8639957931 : ℚ)) * X + C ((-528517507841562 / 2879985977 : ℚ)) * X ^ 2 + C ((-660512123022482 / 2879985977 : ℚ)) * X ^ 3 + C ((-573287901768172 / 2879985977 : ℚ)) * X ^ 4 + C ((-1035872202990731 / 8639957931 : ℚ)) * X ^ 5 + C ((-168548718230325 / 2879985977 : ℚ)) * X ^ 6 + C ((450053643274220 / 8639957931 : ℚ)) * X ^ 7 + C ((1000791452393014 / 8639957931 : ℚ)) * X ^ 8 + C ((1013795415049013 / 8639957931 : ℚ)) * X ^ 9 + C ((1073411420598811 / 8639957931 : ℚ)) * X ^ 10 + C ((1811326572912640 / 8639957931 : ℚ)) * X ^ 11 + C ((2549241725226469 / 8639957931 : ℚ)) * X ^ 12 + C ((2893308940916549 / 8639957931 : ℚ)) * X ^ 13 + C ((1100765583038436 / 2879985977 : ℚ)) * X ^ 14 + C ((1000906883207842 / 2879985977 : ℚ)) * X ^ 15 + C ((25193074740211 / 97078179 : ℚ)) * X ^ 16 + C ((1620886538243803 / 8639957931 : ℚ)) * X ^ 17 + C ((588641244847646 / 8639957931 : ℚ)) * X ^ 18
theorem CV_102_5_pre_eq :
    CV_2_re_001 * Fplus_dW_re_101 - CV_2_im_001 * Fplus_dW_im_101 = CV_102_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001, CV_2_im_001, Fplus_dW_re_101, Fplus_dW_im_101, CV_102_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_5_pim_eq :
    CV_2_re_001 * Fplus_dW_im_101 + CV_2_im_001 * Fplus_dW_re_101 = CV_102_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001, CV_2_im_001, Fplus_dW_re_101, Fplus_dW_im_101, CV_102_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_5_mul :
    CV_2_c_001 * Fplus_dW_c_101 = ofLadj CV_102_5_pre CV_102_5_pim := by
  rw [CV_2_c_001, Fplus_dW_c_101, ofLadj_mul, CV_102_5_pre_eq, CV_102_5_pim_eq]

def CV_102_6_pre : Polynomial ℚ := C ((-221856126346 / 785450721 : ℚ)) + C ((193238813076 / 261816907 : ℚ)) * X ^ 2 + C ((447533593954 / 261816907 : ℚ)) * X ^ 3 + C ((678695926390 / 261816907 : ℚ)) * X ^ 4 + C ((2449323508796 / 785450721 : ℚ)) * X ^ 5 + C ((2449323508796 / 785450721 : ℚ)) * X ^ 6 + C ((678695926390 / 261816907 : ℚ)) * X ^ 7 + C ((447533593954 / 261816907 : ℚ)) * X ^ 8 + C ((193238813076 / 261816907 : ℚ)) * X ^ 9
def CV_102_6_pim : Polynomial ℚ := C ((-8135621734838 / 8639957931 : ℚ)) + C ((-16271243469676 / 8639957931 : ℚ)) * X + C ((-7258958072436 / 2879985977 : ℚ)) * X ^ 2 + C ((-7654321488922 / 2879985977 : ℚ)) * X ^ 3 + C ((-19405834573838 / 8639957931 : ℚ)) * X ^ 4 + C ((-12356220815776 / 8639957931 : ℚ)) * X ^ 5 + C ((-1305007551300 / 2879985977 : ℚ)) * X ^ 6 + C ((3134591104162 / 8639957931 : ℚ)) * X ^ 7 + C ((6691720997090 / 8639957931 : ℚ)) * X ^ 8 + C ((5505630747632 / 8639957931 : ℚ)) * X ^ 9
theorem CV_102_6_neg_re : -CV_3_re_102 = CV_102_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_102, CV_102_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_6_neg_im : -CV_3_im_102 = CV_102_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_102, CV_102_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_102_6_mul : -CV_3_c_102 = ofLadj CV_102_6_pre CV_102_6_pim := by
  rw [CV_3_c_102, ofLadj_neg, CV_102_6_neg_re, CV_102_6_neg_im]

def CV_coeff_102 : Ki := CV_0_c_100 * Fplus_dU_c_002 + CV_0_c_001 * Fplus_dU_c_101 + CV_1_c_100 * Fplus_dV_c_002 + CV_1_c_001 * Fplus_dV_c_101 + CV_2_c_100 * Fplus_dW_c_002 + CV_2_c_001 * Fplus_dW_c_101 + (-CV_3_c_102)

theorem CV_coeff_102_sum :
    CV_coeff_102 = ofLadj (CV_102_0_pre + CV_102_1_pre + CV_102_2_pre + CV_102_3_pre + CV_102_4_pre + CV_102_5_pre + CV_102_6_pre) (CV_102_0_pim + CV_102_1_pim + CV_102_2_pim + CV_102_3_pim + CV_102_4_pim + CV_102_5_pim + CV_102_6_pim) := by
  simp only [CV_coeff_102, CV_102_0_mul, CV_102_1_mul, CV_102_2_mul, CV_102_3_mul, CV_102_4_mul, CV_102_5_mul, CV_102_6_mul]
  simp [ofLadj_add, add_assoc]

def CV_102_qre : Polynomial ℚ := C ((-58076941804538 / 8639957931 : ℚ)) + C ((315815717073602 / 2879985977 : ℚ)) * X + C ((2256950842252781 / 17279915862 : ℚ)) * X ^ 2 + C ((1484951572467433 / 8639957931 : ℚ)) * X ^ 3 + C ((2113744522905772 / 8639957931 : ℚ)) * X ^ 4 + C ((1434253419786181 / 8639957931 : ℚ)) * X ^ 5 + C ((1313273509552285 / 8639957931 : ℚ)) * X ^ 6 + C ((582983521111135 / 5759971954 : ℚ)) * X ^ 7 + C ((-10356302737883 / 8639957931 : ℚ)) * X ^ 8
def CV_102_qim : Polynomial ℚ := C ((-336736614909237 / 2879985977 : ℚ)) + C ((-336736614909237 / 2879985977 : ℚ)) * X + C ((-1513025837311225 / 17279915862 : ℚ)) * X ^ 2 + C ((-852843113900267 / 8639957931 : ℚ)) * X ^ 3 + C ((12191655845453 / 8639957931 : ℚ)) * X ^ 4 + C ((620122907142203 / 8639957931 : ℚ)) * X ^ 5 + C ((535593637166222 / 8639957931 : ℚ)) * X ^ 6 + C ((793019220957509 / 5759971954 : ℚ)) * X ^ 7 + C ((710421044941811 / 8639957931 : ℚ)) * X ^ 8
theorem CV_coeff_102_poly_re :
    CV_102_0_pre + CV_102_1_pre + CV_102_2_pre + CV_102_3_pre + CV_102_4_pre + CV_102_5_pre + CV_102_6_pre = (0 : Polynomial ℚ) + Phi11 * CV_102_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_102_0_pre, CV_102_1_pre, CV_102_2_pre, CV_102_3_pre, CV_102_4_pre, CV_102_5_pre, CV_102_6_pre, CV_102_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_102_poly_im :
    CV_102_0_pim + CV_102_1_pim + CV_102_2_pim + CV_102_3_pim + CV_102_4_pim + CV_102_5_pim + CV_102_6_pim = (0 : Polynomial ℚ) + Phi11 * CV_102_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_102_0_pim, CV_102_1_pim, CV_102_2_pim, CV_102_3_pim, CV_102_4_pim, CV_102_5_pim, CV_102_6_pim, CV_102_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_102_eq :
    CV_coeff_102 = (0 : Ki) := by
  rw [CV_coeff_102_sum, CV_coeff_102_poly_re,
    CV_coeff_102_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
