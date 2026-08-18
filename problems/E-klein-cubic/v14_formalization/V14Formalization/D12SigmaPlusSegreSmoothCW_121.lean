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

def CW_121_0_pre : Polynomial ℚ := C ((-173536730102 / 2879985977 : ℚ)) + C ((5266991538920 / 2879985977 : ℚ)) * X + C ((9590711178956 / 2879985977 : ℚ)) * X ^ 2 + C ((16830291192706 / 2879985977 : ℚ)) * X ^ 3 + C ((76701076280200 / 8639957931 : ℚ)) * X ^ 4 + C ((87582569299273 / 8639957931 : ℚ)) * X ^ 5 + C ((9360801198031 / 785450721 : ℚ)) * X ^ 6 + C ((35522260322444 / 2879985977 : ℚ)) * X ^ 7 + C ((33797782065698 / 2879985977 : ℚ)) * X ^ 8 + C ((3010600855051 / 261816907 : ℚ)) * X ^ 9 + C ((32644941684532 / 2879985977 : ℚ)) * X ^ 10 + C ((32582371960296 / 2879985977 : ℚ)) * X ^ 11 + C ((2488904558692 / 261816907 : ℚ)) * X ^ 12 + C ((23525898226605 / 2879985977 : ℚ)) * X ^ 13 + C ((1542499170272 / 261816907 : ℚ)) * X ^ 14 + C ((8815228658614 / 2879985977 : ℚ)) * X ^ 15 + C ((16752820115974 / 8639957931 : ℚ)) * X ^ 16 + C ((455525412302 / 2879985977 : ℚ)) * X ^ 17 + C ((-3420018711290 / 8639957931 : ℚ)) * X ^ 18
def CW_121_0_pim : Polynomial ℚ := C ((-11343440538596 / 8639957931 : ℚ)) + C ((-22686881077192 / 8639957931 : ℚ)) * X + C ((-25212780990718 / 8639957931 : ℚ)) * X ^ 2 + C ((-11344152916324 / 2879985977 : ℚ)) * X ^ 3 + C ((-22854605237780 / 8639957931 : ℚ)) * X ^ 4 + C ((-11808958206017 / 8639957931 : ℚ)) * X ^ 5 + C ((-185286359635 / 2879985977 : ℚ)) * X ^ 6 + C ((17837331311210 / 8639957931 : ℚ)) * X ^ 7 + C ((25172869955408 / 8639957931 : ℚ)) * X ^ 8 + C ((8269737886495 / 2879985977 : ℚ)) * X ^ 9 + C ((23604335547700 / 8639957931 : ℚ)) * X ^ 10 + C ((32969320541438 / 8639957931 : ℚ)) * X ^ 11 + C ((14111435178392 / 2879985977 : ℚ)) * X ^ 12 + C ((43655327336917 / 8639957931 : ℚ)) * X ^ 13 + C ((52111348799248 / 8639957931 : ℚ)) * X ^ 14 + C ((13933652652452 / 2879985977 : ℚ)) * X ^ 15 + C ((32329471845908 / 8639957931 : ℚ)) * X ^ 16 + C ((7762368481566 / 2879985977 : ℚ)) * X ^ 17 + C ((2156025324966 / 2879985977 : ℚ)) * X ^ 18
theorem CW_121_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_011 - CW_0_im_110 * Fplus_dU_im_011 = CW_121_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_121_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_011 + CW_0_im_110 * Fplus_dU_re_011 = CW_121_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_121_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_0_mul :
    CW_0_c_110 * Fplus_dU_c_011 = ofLadj CW_121_0_pre CW_121_0_pim := by
  rw [CW_0_c_110_def, Fplus_dU_c_011_def, ofLadj_mul, CW_121_0_pre_eq, CW_121_0_pim_eq]

def CW_121_1_pre : Polynomial ℚ := C ((-1918957331752 / 8639957931 : ℚ)) + C ((11806892985152 / 8639957931 : ℚ)) * X + C ((5489278442800 / 2879985977 : ℚ)) * X ^ 2 + C ((27333485270950 / 8639957931 : ℚ)) * X ^ 3 + C ((15078597064728 / 2879985977 : ℚ)) * X ^ 4 + C ((42273347400920 / 8639957931 : ℚ)) * X ^ 5 + C ((55805267335174 / 8639957931 : ℚ)) * X ^ 6 + C ((51747537049354 / 8639957931 : ℚ)) * X ^ 7 + C ((16392595117384 / 2879985977 : ℚ)) * X ^ 8 + C ((16232624127708 / 2879985977 : ℚ)) * X ^ 9 + C ((47662177493806 / 8639957931 : ℚ)) * X ^ 10 + C ((16623685342360 / 2879985977 : ℚ)) * X ^ 11 + C ((35855284508654 / 8639957931 : ℚ)) * X ^ 12 + C ((10743345684908 / 2879985977 : ℚ)) * X ^ 13 + C ((21844300081202 / 8639957931 : ℚ)) * X ^ 14 + C ((4888024364282 / 8639957931 : ℚ)) * X ^ 15 + C ((8161511575828 / 8639957931 : ℚ)) * X ^ 16 + C ((-5370408358426 / 8639957931 : ℚ)) * X ^ 17 + C ((-1623721490888 / 8639957931 : ℚ)) * X ^ 18
def CW_121_1_pim : Polynomial ℚ := C ((-7674705254792 / 8639957931 : ℚ)) + C ((-15349410509584 / 8639957931 : ℚ)) * X + C ((-10078170708728 / 8639957931 : ℚ)) * X ^ 2 + C ((-21072132248614 / 8639957931 : ℚ)) * X ^ 3 + C ((-7210722729268 / 8639957931 : ℚ)) * X ^ 4 + C ((-3298359152708 / 8639957931 : ℚ)) * X ^ 5 + C ((1668617491546 / 8639957931 : ℚ)) * X ^ 6 + C ((14492285589926 / 8639957931 : ℚ)) * X ^ 7 + C ((14022386894128 / 8639957931 : ℚ)) * X ^ 8 + C ((14187905810864 / 8639957931 : ℚ)) * X ^ 9 + C ((4504654499174 / 2879985977 : ℚ)) * X ^ 10 + C ((20462133347576 / 8639957931 : ℚ)) * X ^ 11 + C ((27410303197630 / 8639957931 : ℚ)) * X ^ 12 + C ((7155040361144 / 2879985977 : ℚ)) * X ^ 13 + C ((10874867180018 / 2879985977 : ℚ)) * X ^ 14 + C ((18698822471854 / 8639957931 : ℚ)) * X ^ 15 + C ((15937043345156 / 8639957931 : ℚ)) * X ^ 16 + C ((11267554501574 / 8639957931 : ℚ)) * X ^ 17 + C ((-405529146944 / 8639957931 : ℚ)) * X ^ 18
theorem CW_121_1_pre_eq :
    CW_0_re_020 * Fplus_dU_re_101 - CW_0_im_020 * Fplus_dU_im_101 = CW_121_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_121_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_1_pim_eq :
    CW_0_re_020 * Fplus_dU_im_101 + CW_0_im_020 * Fplus_dU_re_101 = CW_121_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_121_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_1_mul :
    CW_0_c_020 * Fplus_dU_c_101 = ofLadj CW_121_1_pre CW_121_1_pim := by
  rw [CW_0_c_020_def, Fplus_dU_c_101_def, ofLadj_mul, CW_121_1_pre_eq, CW_121_1_pim_eq]

def CW_121_2_pre : Polynomial ℚ := C ((598641117592 / 2879985977 : ℚ)) + C ((-7129002716472 / 2879985977 : ℚ)) * X + C ((-12747140618249 / 2879985977 : ℚ)) * X ^ 2 + C ((-21870957100591 / 2879985977 : ℚ)) * X ^ 3 + C ((-100611156320381 / 8639957931 : ℚ)) * X ^ 4 + C ((-114170448896626 / 8639957931 : ℚ)) * X ^ 5 + C ((-12314357106316 / 785450721 : ℚ)) * X ^ 6 + C ((-141404955992170 / 8639957931 : ℚ)) * X ^ 7 + C ((-134896424952955 / 8639957931 : ℚ)) * X ^ 8 + C ((-132877346389063 / 8639957931 : ℚ)) * X ^ 9 + C ((-132275615136509 / 8639957931 : ℚ)) * X ^ 10 + C ((-4025393062232 / 261816907 : ℚ)) * X ^ 11 + C ((-110888606987093 / 8639957931 : ℚ)) * X ^ 12 + C ((-782115078796 / 71404611 : ℚ)) * X ^ 13 + C ((-69283553651182 / 8639957931 : ℚ)) * X ^ 14 + C ((-35321205994645 / 8639957931 : ℚ)) * X ^ 15 + C ((-7641987119576 / 2879985977 : ℚ)) * X ^ 16 + C ((-148952916898 / 785450721 : ℚ)) * X ^ 17 + C ((497508516104 / 785450721 : ℚ)) * X ^ 18
def CW_121_2_pim : Polynomial ℚ := C ((5308690288268 / 2879985977 : ℚ)) + C ((10617380576536 / 2879985977 : ℚ)) * X + C ((33720482847091 / 8639957931 : ℚ)) * X ^ 2 + C ((47002646398739 / 8639957931 : ℚ)) * X ^ 3 + C ((31783345738843 / 8639957931 : ℚ)) * X ^ 4 + C ((17503982496608 / 8639957931 : ℚ)) * X ^ 5 + C ((3205145791268 / 8639957931 : ℚ)) * X ^ 6 + C ((-21297829041406 / 8639957931 : ℚ)) * X ^ 7 + C ((-32622079152611 / 8639957931 : ℚ)) * X ^ 8 + C ((-10641782057171 / 2879985977 : ℚ)) * X ^ 9 + C ((-31180772647273 / 8639957931 : ℚ)) * X ^ 10 + C ((-45482687419150 / 8639957931 : ℚ)) * X ^ 11 + C ((-59784602191027 / 8639957931 : ℚ)) * X ^ 12 + C ((-20302789928090 / 2879985977 : ℚ)) * X ^ 13 + C ((-73493800354820 / 8639957931 : ℚ)) * X ^ 14 + C ((-59532754859051 / 8639957931 : ℚ)) * X ^ 15 + C ((-15301610296678 / 2879985977 : ℚ)) * X ^ 16 + C ((-11305843502178 / 2879985977 : ℚ)) * X ^ 17 + C ((-3355331649026 / 2879985977 : ℚ)) * X ^ 18
theorem CW_121_2_pre_eq :
    CW_1_re_110 * Fplus_dV_re_011 - CW_1_im_110 * Fplus_dV_im_011 = CW_121_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_121_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_2_pim_eq :
    CW_1_re_110 * Fplus_dV_im_011 + CW_1_im_110 * Fplus_dV_re_011 = CW_121_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_121_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_2_mul :
    CW_1_c_110 * Fplus_dV_c_011 = ofLadj CW_121_2_pre CW_121_2_pim := by
  rw [CW_1_c_110_def, Fplus_dV_c_011_def, ofLadj_mul, CW_121_2_pre_eq, CW_121_2_pim_eq]

def CW_121_3_pre : Polynomial ℚ := C ((2165098877800 / 8639957931 : ℚ)) + C ((-4772905271840 / 8639957931 : ℚ)) * X + C ((-5734933945792 / 8639957931 : ℚ)) * X ^ 2 + C ((-14136657923836 / 8639957931 : ℚ)) * X ^ 3 + C ((-22746397331260 / 8639957931 : ℚ)) * X ^ 4 + C ((-7318453892854 / 2879985977 : ℚ)) * X ^ 5 + C ((-30943020682694 / 8639957931 : ℚ)) * X ^ 6 + C ((-29073596965678 / 8639957931 : ℚ)) * X ^ 7 + C ((-9028162867100 / 2879985977 : ℚ)) * X ^ 8 + C ((-26446359614504 / 8639957931 : ℚ)) * X ^ 9 + C ((-8681898109902 / 2879985977 : ℚ)) * X ^ 10 + C ((-27766969952672 / 8639957931 : ℚ)) * X ^ 11 + C ((-21272789057866 / 8639957931 : ℚ)) * X ^ 12 + C ((-20711425668712 / 8639957931 : ℚ)) * X ^ 13 + C ((-12947830677464 / 8639957931 : ℚ)) * X ^ 14 + C ((-4789600650394 / 8639957931 : ℚ)) * X ^ 15 + C ((-6119987470144 / 8639957931 : ℚ)) * X ^ 16 + C ((2867671533988 / 8639957931 : ℚ)) * X ^ 17 + C ((1537598984024 / 8639957931 : ℚ)) * X ^ 18
def CW_121_3_pim : Polynomial ℚ := C ((4263045328004 / 8639957931 : ℚ)) + C ((8526090656008 / 8639957931 : ℚ)) * X + C ((8114829230920 / 8639957931 : ℚ)) * X ^ 2 + C ((15217104950644 / 8639957931 : ℚ)) * X ^ 3 + C ((7026338006384 / 8639957931 : ℚ)) * X ^ 4 + C ((7156601248034 / 8639957931 : ℚ)) * X ^ 5 + C ((4117449648398 / 8639957931 : ℚ)) * X ^ 6 + C ((-3647864470186 / 8639957931 : ℚ)) * X ^ 7 + C ((-3819734295464 / 8639957931 : ℚ)) * X ^ 8 + C ((-3651741158908 / 8639957931 : ℚ)) * X ^ 9 + C ((-3397896122150 / 8639957931 : ℚ)) * X ^ 10 + C ((-6954613939072 / 8639957931 : ℚ)) * X ^ 11 + C ((-3503777251998 / 2879985977 : ℚ)) * X ^ 12 + C ((-9846225294148 / 8639957931 : ℚ)) * X ^ 13 + C ((-5593502625772 / 2879985977 : ℚ)) * X ^ 14 + C ((-2964070597718 / 2879985977 : ℚ)) * X ^ 15 + C ((-9390034718860 / 8639957931 : ℚ)) * X ^ 16 + C ((-7267153399708 / 8639957931 : ℚ)) * X ^ 17 + C ((130601034820 / 8639957931 : ℚ)) * X ^ 18
theorem CW_121_3_pre_eq :
    CW_1_re_020 * Fplus_dV_re_101 - CW_1_im_020 * Fplus_dV_im_101 = CW_121_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_121_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_3_pim_eq :
    CW_1_re_020 * Fplus_dV_im_101 + CW_1_im_020 * Fplus_dV_re_101 = CW_121_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_121_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_3_mul :
    CW_1_c_020 * Fplus_dV_c_101 = ofLadj CW_121_3_pre CW_121_3_pim := by
  rw [CW_1_c_020_def, Fplus_dV_c_101_def, ofLadj_mul, CW_121_3_pre_eq, CW_121_3_pim_eq]

def CW_121_4_pre : Polynomial ℚ := C ((-2112007604 / 32359393 : ℚ)) + C ((-636429488 / 32359393 : ℚ)) * X + C ((-10715461804 / 97078179 : ℚ)) * X ^ 2 + C ((-13169824396 / 97078179 : ℚ)) * X ^ 3 + C ((-16305347339 / 97078179 : ℚ)) * X ^ 4 + C ((-8521094535 / 32359393 : ℚ)) * X ^ 5 + C ((-22006330655 / 97078179 : ℚ)) * X ^ 6 + C ((-9647177038 / 32359393 : ℚ)) * X ^ 7 + C ((-26403945749 / 97078179 : ℚ)) * X ^ 8 + C ((-26806837358 / 97078179 : ℚ)) * X ^ 9 + C ((-7673640795 / 32359393 : ℚ)) * X ^ 10 + C ((-18861494534 / 97078179 : ℚ)) * X ^ 11 + C ((-7037211307 / 32359393 : ℚ)) * X ^ 12 + C ((-16091375554 / 97078179 : ℚ)) * X ^ 13 + C ((-13234121353 / 97078179 : ℚ)) * X ^ 14 + C ((-4128503737 / 32359393 : ℚ)) * X ^ 15 + C ((-900970196 / 32359393 : ℚ)) * X ^ 16 + C ((-6259863538 / 97078179 : ℚ)) * X ^ 17 + C ((250672564 / 97078179 : ℚ)) * X ^ 18
def CW_121_4_pim : Polynomial ℚ := C ((1224830 / 267433 : ℚ)) + C ((2449660 / 267433 : ℚ)) * X + C ((2205463448 / 32359393 : ℚ)) * X ^ 2 + C ((-513109358 / 32359393 : ℚ)) * X ^ 3 + C ((2164322095 / 32359393 : ℚ)) * X ^ 4 + C ((-2497976029 / 97078179 : ℚ)) * X ^ 5 + C ((-4200642763 / 97078179 : ℚ)) * X ^ 6 + C ((-7666325752 / 97078179 : ℚ)) * X ^ 7 + C ((-10842779521 / 97078179 : ℚ)) * X ^ 8 + C ((-13005447164 / 97078179 : ℚ)) * X ^ 9 + C ((-3936734357 / 32359393 : ℚ)) * X ^ 10 + C ((-10463464936 / 97078179 : ℚ)) * X ^ 11 + C ((-9116726801 / 97078179 : ℚ)) * X ^ 12 + C ((-4549548824 / 32359393 : ℚ)) * X ^ 13 + C ((-7655595697 / 97078179 : ℚ)) * X ^ 14 + C ((-13564925897 / 97078179 : ℚ)) * X ^ 15 + C ((-8027484478 / 97078179 : ℚ)) * X ^ 16 + C ((-5311600022 / 97078179 : ℚ)) * X ^ 17 + C ((-5299417928 / 97078179 : ℚ)) * X ^ 18
theorem CW_121_4_pre_eq :
    CW_2_re_110 * Fplus_dW_re_011 - CW_2_im_110 * Fplus_dW_im_011 = CW_121_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_121_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_4_pim_eq :
    CW_2_re_110 * Fplus_dW_im_011 + CW_2_im_110 * Fplus_dW_re_011 = CW_121_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_121_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_4_mul :
    CW_2_c_110 * Fplus_dW_c_011 = ofLadj CW_121_4_pre CW_121_4_pim := by
  rw [CW_2_c_110_def, Fplus_dW_c_011_def, ofLadj_mul, CW_121_4_pre_eq, CW_121_4_pim_eq]

def CW_121_5_pre : Polynomial ℚ := C ((10458629076920 / 8639957931 : ℚ)) + C ((203706884864 / 8639957931 : ℚ)) * X + C ((17148417784372 / 8639957931 : ℚ)) * X ^ 2 + C ((23986857126062 / 8639957931 : ℚ)) * X ^ 3 + C ((7507435298850 / 2879985977 : ℚ)) * X ^ 4 + C ((40893412823096 / 8639957931 : ℚ)) * X ^ 5 + C ((34701620594822 / 8639957931 : ℚ)) * X ^ 6 + C ((46418077001168 / 8639957931 : ℚ)) * X ^ 7 + C ((14669585660420 / 2879985977 : ℚ)) * X ^ 8 + C ((43848301661812 / 8639957931 : ℚ)) * X ^ 9 + C ((45021358440236 / 8639957931 : ℚ)) * X ^ 10 + C ((11153719998172 / 2879985977 : ℚ)) * X ^ 11 + C ((14939217185124 / 2879985977 : ℚ)) * X ^ 12 + C ((8899961292480 / 2879985977 : ℚ)) * X ^ 13 + C ((20021899855198 / 8639957931 : ℚ)) * X ^ 14 + C ((1861511786774 / 785450721 : ℚ)) * X ^ 15 + C ((774791408322 / 2879985977 : ℚ)) * X ^ 16 + C ((2838722151080 / 2879985977 : ℚ)) * X ^ 17 + C ((-3419141450104 / 8639957931 : ℚ)) * X ^ 18
def CW_121_5_pim : Polynomial ℚ := C ((3916485379012 / 8639957931 : ℚ)) + C ((7832970758024 / 8639957931 : ℚ)) * X + C ((-178566465996 / 261816907 : ℚ)) * X ^ 2 + C ((14249367939574 / 8639957931 : ℚ)) * X ^ 3 + C ((4940778048938 / 8639957931 : ℚ)) * X ^ 4 + C ((16455374162488 / 8639957931 : ℚ)) * X ^ 5 + C ((23313238738786 / 8639957931 : ℚ)) * X ^ 6 + C ((25742980706752 / 8639957931 : ℚ)) * X ^ 7 + C ((12854479930516 / 2879985977 : ℚ)) * X ^ 8 + C ((38045936452760 / 8639957931 : ℚ)) * X ^ 9 + C ((38886209075752 / 8639957931 : ℚ)) * X ^ 10 + C ((11711573965720 / 2879985977 : ℚ)) * X ^ 11 + C ((31383234718568 / 8639957931 : ℚ)) * X ^ 12 + C ((15316390492484 / 2879985977 : ℚ)) * X ^ 13 + C ((25289606821222 / 8639957931 : ℚ)) * X ^ 14 + C ((35147776202614 / 8639957931 : ℚ)) * X ^ 15 + C ((22202510767198 / 8639957931 : ℚ)) * X ^ 16 + C ((16131290883872 / 8639957931 : ℚ)) * X ^ 17 + C ((12270879594040 / 8639957931 : ℚ)) * X ^ 18
theorem CW_121_5_pre_eq :
    CW_2_re_020 * Fplus_dW_re_101 - CW_2_im_020 * Fplus_dW_im_101 = CW_121_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_121_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_5_pim_eq :
    CW_2_re_020 * Fplus_dW_im_101 + CW_2_im_020 * Fplus_dW_re_101 = CW_121_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_121_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_121_5_mul :
    CW_2_c_020 * Fplus_dW_c_101 = ofLadj CW_121_5_pre CW_121_5_pim := by
  rw [CW_2_c_020_def, Fplus_dW_c_101_def, ofLadj_mul, CW_121_5_pre_eq, CW_121_5_pim_eq]

theorem CW_121_6_mul : CW_3_c_120 = ofLadj CW_3_re_120 CW_3_im_120 := CW_3_c_120_def

@[expose] public def CW_coeff_121 : Ki := CW_0_c_110 * Fplus_dU_c_011 + CW_0_c_020 * Fplus_dU_c_101 + CW_1_c_110 * Fplus_dV_c_011 + CW_1_c_020 * Fplus_dV_c_101 + CW_2_c_110 * Fplus_dW_c_011 + CW_2_c_020 * Fplus_dW_c_101 + CW_3_c_120

theorem CW_coeff_121_sum :
    CW_coeff_121 = ofLadj (CW_121_0_pre + CW_121_1_pre + CW_121_2_pre + CW_121_3_pre + CW_121_4_pre + CW_121_5_pre + CW_3_re_120) (CW_121_0_pim + CW_121_1_pim + CW_121_2_pim + CW_121_3_pim + CW_121_4_pim + CW_121_5_pim + CW_3_im_120) := by
  simp only [CW_coeff_121, CW_121_0_mul, CW_121_1_mul, CW_121_2_mul, CW_121_3_mul, CW_121_4_mul, CW_121_5_mul, CW_121_6_mul]
  simp [ofLadj_add, add_assoc]

def CW_121_qre : Polynomial ℚ := C ((11452471546528 / 8639957931 : ℚ)) + C ((-9970737154304 / 8639957931 : ℚ)) * X + C ((5346107350763 / 2879985977 : ℚ)) * X ^ 2 + C ((37850354588 / 97078179 : ℚ)) * X ^ 3 + C ((-412590475169 / 2879985977 : ℚ)) * X ^ 4 + C ((4215008268752 / 2879985977 : ℚ)) * X ^ 5 + C ((-7232197879384 / 8639957931 : ℚ)) * X ^ 6 + C ((6614775057866 / 8639957931 : ℚ)) * X ^ 7 + C ((-476793044306 / 2879985977 : ℚ)) * X ^ 8
def CW_121_qim : Polynomial ℚ := C ((5177105229584 / 8639957931 : ℚ)) + C ((5177105229584 / 8639957931 : ℚ)) * X + C ((-9079774464311 / 8639957931 : ℚ)) * X ^ 2 + C ((20030394372020 / 8639957931 : ℚ)) * X ^ 3 + C ((-6945410663431 / 8639957931 : ℚ)) * X ^ 4 + C ((3851865781320 / 2879985977 : ℚ)) * X ^ 5 + C ((1810393236294 / 2879985977 : ℚ)) * X ^ 6 + C ((4127903400 / 32359393 : ℚ)) * X ^ 7 + C ((7926384314144 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_121_poly_re :
    CW_121_0_pre + CW_121_1_pre + CW_121_2_pre + CW_121_3_pre + CW_121_4_pre + CW_121_5_pre + CW_3_re_120 = (0 : Polynomial ℚ) + Phi11 * CW_121_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_121_0_pre, CW_121_1_pre, CW_121_2_pre, CW_121_3_pre, CW_121_4_pre, CW_121_5_pre, CW_3_re_120_def, CW_121_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_121_poly_im :
    CW_121_0_pim + CW_121_1_pim + CW_121_2_pim + CW_121_3_pim + CW_121_4_pim + CW_121_5_pim + CW_3_im_120 = (0 : Polynomial ℚ) + Phi11 * CW_121_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_121_0_pim, CW_121_1_pim, CW_121_2_pim, CW_121_3_pim, CW_121_4_pim, CW_121_5_pim, CW_3_im_120_def, CW_121_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_121_eq :
    CW_coeff_121 = (0 : Ki) := by
  rw [CW_coeff_121_sum, CW_coeff_121_poly_re,
    CW_coeff_121_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
