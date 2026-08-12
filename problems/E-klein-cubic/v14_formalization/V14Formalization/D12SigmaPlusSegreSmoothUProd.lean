/-
Auto-generated Fplus chart Bézout product identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreSmoothU
import V14Formalization.D12SigmaPlusSegreSmoothV
import V14Formalization.D12SigmaPlusSegreSmoothW

noncomputable section
open Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def UP0_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP0_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP0_F : Ki := ofLadj UP0_Fre UP0_Fim
def UP0_pre : Polynomial ℚ := C ((-797469986439 / 275112497 : ℚ)) + C ((713250121861 / 275112497 : ℚ)) * X ^ 2 + C ((2029670842636 / 275112497 : ℚ)) * X ^ 3 + C ((12456104236809 / 550224994 : ℚ)) * X ^ 4 + C ((20906769700945 / 550224994 : ℚ)) * X ^ 5 + C ((29595901052867 / 550224994 : ℚ)) * X ^ 6 + C ((18333572577238 / 275112497 : ℚ)) * X ^ 7 + C ((19671652163452 / 275112497 : ℚ)) * X ^ 8 + C ((40486486187329 / 550224994 : ℚ)) * X ^ 9 + C ((20678286869287 / 275112497 : ℚ)) * X ^ 10 + C ((21638952225877 / 275112497 : ℚ)) * X ^ 11 + C ((20678286869287 / 275112497 : ℚ)) * X ^ 12 + C ((39059985943607 / 550224994 : ℚ)) * X ^ 13 + C ((17641981320816 / 275112497 : ℚ)) * X ^ 14 + C ((25839221450475 / 550224994 : ℚ)) * X ^ 15 + C ((8382167555085 / 275112497 : ℚ)) * X ^ 16 + C ((367054716284 / 25010227 : ℚ)) * X ^ 17 + C ((814090266404 / 275112497 : ℚ)) * X ^ 18
def UP0_pim : Polynomial ℚ := C ((-2724907261578 / 275112497 : ℚ)) + C ((-5449814523156 / 275112497 : ℚ)) * X + C ((-8864723636209 / 275112497 : ℚ)) * X ^ 2 + C ((-13488967586389 / 275112497 : ℚ)) * X ^ 3 + C ((-32709538236785 / 550224994 : ℚ)) * X ^ 4 + C ((-35440345373439 / 550224994 : ℚ)) * X ^ 5 + C ((-18084281704718 / 275112497 : ℚ)) * X ^ 6 + C ((-30899669613295 / 550224994 : ℚ)) * X ^ 7 + C ((-27459422218521 / 550224994 : ℚ)) * X ^ 8 + C ((-13646795210766 / 275112497 : ℚ)) * X ^ 9 + C ((-26539148650023 / 550224994 : ℚ)) * X ^ 10 + C ((-908302420526 / 25010227 : ℚ)) * X ^ 11 + C ((-13426157853121 / 550224994 : ℚ)) * X ^ 12 + C ((-2920948927753 / 275112497 : ℚ)) * X ^ 13 + C ((3572421841843 / 550224994 : ℚ)) * X ^ 14 + C ((401059213615 / 25010227 : ℚ)) * X ^ 15 + C ((10585238695775 / 550224994 : ℚ)) * X ^ 16 + C ((461760660802 / 25010227 : ℚ)) * X ^ 17 + C ((1960484800547 / 275112497 : ℚ)) * X ^ 18
theorem UP0_pre_eq :
    UA_0_0_re * UP0_Fre - UA_0_0_im * UP0_Fim = UP0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP0_Fre, UP0_Fim, UP0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP0_pim_eq :
    UA_0_0_re * UP0_Fim + UA_0_0_im * UP0_Fre = UP0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP0_Fre, UP0_Fim, UP0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP0_mul : UA_0_0 * UP0_F = ofLadj UP0_pre UP0_pim := by
  rw [UA_0_0, UP0_F, ofLadj_mul, UP0_pre_eq, UP0_pim_eq]

def UP1_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def UP1_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def UP1_F : Ki := ofLadj UP1_Fre UP1_Fim
def UP1_pre : Polynomial ℚ := C ((-88316921278 / 825337491 : ℚ)) + C ((14532838728416 / 825337491 : ℚ)) * X + C ((29104874838788 / 825337491 : ℚ)) * X ^ 2 + C ((15808732194637 / 275112497 : ℚ)) * X ^ 3 + C ((80144356734760 / 825337491 : ℚ)) * X ^ 4 + C ((102620008080115 / 825337491 : ℚ)) * X ^ 5 + C ((123726269159050 / 825337491 : ℚ)) * X ^ 6 + C ((44313769876375 / 275112497 : ℚ)) * X ^ 7 + C ((123751773037784 / 825337491 : ℚ)) * X ^ 8 + C ((117158265195827 / 825337491 : ℚ)) * X ^ 9 + C ((112148222108510 / 825337491 : ℚ)) * X ^ 10 + C ((110348210425192 / 825337491 : ℚ)) * X ^ 11 + C ((32538461126698 / 275112497 : ℚ)) * X ^ 12 + C ((29351130119013 / 275112497 : ℚ)) * X ^ 13 + C ((76325576453873 / 825337491 : ℚ)) * X ^ 14 + C ((49646840891135 / 825337491 : ℚ)) * X ^ 15 + C ((30769346733538 / 825337491 : ℚ)) * X ^ 16 + C ((9663085654603 / 825337491 : ℚ)) * X ^ 17 + C ((-1050037334410 / 275112497 : ℚ)) * X ^ 18
def UP1_pim : Polynomial ℚ := C ((-13779527202616 / 825337491 : ℚ)) + C ((-27559054405232 / 825337491 : ℚ)) * X + C ((-3240665350280 / 75030681 : ℚ)) * X ^ 2 + C ((-16288629277655 / 275112497 : ℚ)) * X ^ 3 + C ((-49171015369394 / 825337491 : ℚ)) * X ^ 4 + C ((-12030665920253 / 275112497 : ℚ)) * X ^ 5 + C ((-21596474445922 / 825337491 : ℚ)) * X ^ 6 + C ((2057047685591 / 275112497 : ℚ)) * X ^ 7 + C ((7096098637714 / 275112497 : ℚ)) * X ^ 8 + C ((6777391915895 / 275112497 : ℚ)) * X ^ 9 + C ((5328026531924 / 275112497 : ℚ)) * X ^ 10 + C ((23382065952292 / 825337491 : ℚ)) * X ^ 11 + C ((30780052308812 / 825337491 : ℚ)) * X ^ 12 + C ((34520220604747 / 825337491 : ℚ)) * X ^ 13 + C ((15594223139725 / 275112497 : ℚ)) * X ^ 14 + C ((49863897810293 / 825337491 : ℚ)) * X ^ 15 + C ((42362682583184 / 825337491 : ℚ)) * X ^ 16 + C ((34530867122849 / 825337491 : ℚ)) * X ^ 17 + C ((4113684000560 / 275112497 : ℚ)) * X ^ 18
theorem UP1_pre_eq :
    UA_0_0_re * UP1_Fre - UA_0_0_im * UP1_Fim = UP1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP1_Fre, UP1_Fim, UP1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP1_pim_eq :
    UA_0_0_re * UP1_Fim + UA_0_0_im * UP1_Fre = UP1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP1_Fre, UP1_Fim, UP1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP1_mul : UA_0_0 * UP1_F = ofLadj UP1_pre UP1_pim := by
  rw [UA_0_0, UP1_F, ofLadj_mul, UP1_pre_eq, UP1_pim_eq]

def UP2_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def UP2_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def UP2_F : Ki := ofLadj UP2_Fre UP2_Fim
def UP2_pre : Polynomial ℚ := C ((-8153078836904 / 825337491 : ℚ)) + C ((-58131354913664 / 825337491 : ℚ)) * X + C ((-109668136844252 / 825337491 : ℚ)) * X ^ 2 + C ((-172500363169616 / 825337491 : ℚ)) * X ^ 3 + C ((-81844309408364 / 275112497 : ℚ)) * X ^ 4 + C ((-281513345258620 / 825337491 : ℚ)) * X ^ 5 + C ((-308114376145625 / 825337491 : ℚ)) * X ^ 6 + C ((-320536588998278 / 825337491 : ℚ)) * X ^ 7 + C ((-98967847715709 / 275112497 : ℚ)) * X ^ 8 + C ((-292399122247633 / 825337491 : ℚ)) * X ^ 9 + C ((-288965042737876 / 825337491 : ℚ)) * X ^ 10 + C ((-93175629850606 / 275112497 : ℚ)) * X ^ 11 + C ((-20984880711292 / 75030681 : ℚ)) * X ^ 12 + C ((-182730985403381 / 825337491 : ℚ)) * X ^ 13 + C ((-124403179977511 / 825337491 : ℚ)) * X ^ 14 + C ((-55505061830102 / 825337491 : ℚ)) * X ^ 15 + C ((-21986665110565 / 825337491 : ℚ)) * X ^ 16 + C ((1538121925480 / 275112497 : ℚ)) * X ^ 17 + C ((6499532981028 / 275112497 : ℚ)) * X ^ 18
def UP2_pim : Polynomial ℚ := C ((8684143784544 / 275112497 : ℚ)) + C ((17368287569088 / 275112497 : ℚ)) * X + C ((49597724291876 / 825337491 : ℚ)) * X ^ 2 + C ((49336306174850 / 825337491 : ℚ)) * X ^ 3 + C ((4453897627672 / 275112497 : ℚ)) * X ^ 4 + C ((-42490211956132 / 825337491 : ℚ)) * X ^ 5 + C ((-85263017996773 / 825337491 : ℚ)) * X ^ 6 + C ((-139713986829854 / 825337491 : ℚ)) * X ^ 7 + C ((-169930126329221 / 825337491 : ℚ)) * X ^ 8 + C ((-56426881159247 / 275112497 : ℚ)) * X ^ 9 + C ((-166304715772750 / 825337491 : ℚ)) * X ^ 10 + C ((-187991715543872 / 825337491 : ℚ)) * X ^ 11 + C ((-69892905104998 / 275112497 : ℚ)) * X ^ 12 + C ((-68065216398205 / 275112497 : ℚ)) * X ^ 13 + C ((-18480431656919 / 75030681 : ℚ)) * X ^ 14 + C ((-169202380565734 / 825337491 : ℚ)) * X ^ 15 + C ((-117172896903625 / 825337491 : ℚ)) * X ^ 16 + C ((-78952441523950 / 825337491 : ℚ)) * X ^ 17 + C ((-28323893867908 / 825337491 : ℚ)) * X ^ 18
theorem UP2_pre_eq :
    UA_0_0_re * UP2_Fre - UA_0_0_im * UP2_Fim = UP2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP2_Fre, UP2_Fim, UP2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP2_pim_eq :
    UA_0_0_re * UP2_Fim + UA_0_0_im * UP2_Fre = UP2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP2_Fre, UP2_Fim, UP2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP2_mul : UA_0_0 * UP2_F = ofLadj UP2_pre UP2_pim := by
  rw [UA_0_0, UP2_F, ofLadj_mul, UP2_pre_eq, UP2_pim_eq]

def UP3_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def UP3_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def UP3_F : Ki := ofLadj UP3_Fre UP3_Fim
def UP3_pre : Polynomial ℚ := C ((22515512809 / 825337491 : ℚ)) + C ((18166048410520 / 825337491 : ℚ)) * X + C ((34449366272591 / 825337491 : ℚ)) * X ^ 2 + C ((19769378132458 / 275112497 : ℚ)) * X ^ 3 + C ((96760718978471 / 825337491 : ℚ)) * X ^ 4 + C ((124881375431126 / 825337491 : ℚ)) * X ^ 5 + C ((152196371263414 / 825337491 : ℚ)) * X ^ 6 + C ((174278983498336 / 825337491 : ℚ)) * X ^ 7 + C ((59062616039843 / 275112497 : ℚ)) * X ^ 8 + C ((61128529820871 / 275112497 : ℚ)) * X ^ 9 + C ((62696398683762 / 275112497 : ℚ)) * X ^ 10 + C ((189842335327837 / 825337491 : ℚ)) * X ^ 11 + C ((169923147640766 / 825337491 : ℚ)) * X ^ 12 + C ((148936223190022 / 825337491 : ℚ)) * X ^ 13 + C ((3572112537035 / 25010227 : ℚ)) * X ^ 14 + C ((6795780119597 / 75030681 : ℚ)) * X ^ 15 + C ((14417382549931 / 275112497 : ℚ)) * X ^ 16 + C ((15937151817505 / 825337491 : ℚ)) * X ^ 17 + C ((-2764683204298 / 825337491 : ℚ)) * X ^ 18
def UP3_pim : Polynomial ℚ := C ((-16770257793007 / 825337491 : ℚ)) + C ((-33540515586014 / 825337491 : ℚ)) * X + C ((-15115030311619 / 275112497 : ℚ)) * X ^ 2 + C ((-21213219221839 / 275112497 : ℚ)) * X ^ 3 + C ((-66632594480615 / 825337491 : ℚ)) * X ^ 4 + C ((-59210726037224 / 825337491 : ℚ)) * X ^ 5 + C ((-17304552693614 / 275112497 : ℚ)) * X ^ 6 + C ((-10289162986067 / 275112497 : ℚ)) * X ^ 7 + C ((-15781515319948 / 825337491 : ℚ)) * X ^ 8 + C ((-14880143735101 / 825337491 : ℚ)) * X ^ 9 + C ((-10795384911455 / 825337491 : ℚ)) * X ^ 10 + C ((3989945483457 / 275112497 : ℚ)) * X ^ 11 + C ((34735057812197 / 825337491 : ℚ)) * X ^ 12 + C ((50624391984686 / 825337491 : ℚ)) * X ^ 13 + C ((6347302754563 / 75030681 : ℚ)) * X ^ 14 + C ((70201753017428 / 825337491 : ℚ)) * X ^ 15 + C ((57541276429139 / 825337491 : ℚ)) * X ^ 16 + C ((3998387727605 / 75030681 : ℚ)) * X ^ 17 + C ((17697487736116 / 825337491 : ℚ)) * X ^ 18
theorem UP3_pre_eq :
    UA_0_0_re * UP3_Fre - UA_0_0_im * UP3_Fim = UP3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP3_Fre, UP3_Fim, UP3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP3_pim_eq :
    UA_0_0_re * UP3_Fim + UA_0_0_im * UP3_Fre = UP3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP3_Fre, UP3_Fim, UP3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP3_mul : UA_0_0 * UP3_F = ofLadj UP3_pre UP3_pim := by
  rw [UA_0_0, UP3_F, ofLadj_mul, UP3_pre_eq, UP3_pim_eq]

def UP4_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP4_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP4_F : Ki := ofLadj UP4_Fre UP4_Fim
def UP4_pre : Polynomial ℚ := C ((5406528627496 / 825337491 : ℚ)) + C ((72664193642080 / 825337491 : ℚ)) * X + C ((49329537352992 / 275112497 : ℚ)) * X ^ 2 + C ((243211283180054 / 825337491 : ℚ)) * X ^ 3 + C ((362028395498564 / 825337491 : ℚ)) * X ^ 4 + C ((430313791667548 / 825337491 : ℚ)) * X ^ 5 + C ((485127948304916 / 825337491 : ℚ)) * X ^ 6 + C ((515352011066776 / 825337491 : ℚ)) * X ^ 7 + C ((163654851087126 / 275112497 : ℚ)) * X ^ 8 + C ((481687853727862 / 825337491 : ℚ)) * X ^ 9 + C ((474597209257418 / 825337491 : ℚ)) * X ^ 10 + C ((155517085081216 / 275112497 : ℚ)) * X ^ 11 + C ((401933015615338 / 825337491 : ℚ)) * X ^ 12 + C ((333699241668886 / 825337491 : ℚ)) * X ^ 13 + C ((247753270081324 / 825337491 : ℚ)) * X ^ 14 + C ((45822268829892 / 275112497 : ℚ)) * X ^ 15 + C ((24750815024378 / 275112497 : ℚ)) * X ^ 16 + C ((19438288435766 / 825337491 : ℚ)) * X ^ 17 + C ((-15856809078536 / 825337491 : ℚ)) * X ^ 18
def UP4_pim : Polynomial ℚ := C ((-16304994253836 / 275112497 : ℚ)) + C ((-32609988507672 / 275112497 : ℚ)) * X + C ((-116137958063264 / 825337491 : ℚ)) * X ^ 2 + C ((-136644806286434 / 825337491 : ℚ)) * X ^ 3 + C ((-34275702178936 / 275112497 : ℚ)) * X ^ 4 + C ((-11880859884496 / 275112497 : ℚ)) * X ^ 5 + C ((1652017289920 / 75030681 : ℚ)) * X ^ 6 + C ((97183148634028 / 825337491 : ℚ)) * X ^ 7 + C ((142595701134292 / 825337491 : ℚ)) * X ^ 8 + C ((141264910395200 / 825337491 : ℚ)) * X ^ 9 + C ((45041426879630 / 275112497 : ℚ)) * X ^ 10 + C ((175041684675124 / 825337491 : ℚ)) * X ^ 11 + C ((214959088711358 / 825337491 : ℚ)) * X ^ 12 + C ((227126451495296 / 825337491 : ℚ)) * X ^ 13 + C ((82100836326458 / 275112497 : ℚ)) * X ^ 14 + C ((72125030975160 / 275112497 : ℚ)) * X ^ 15 + C ((52360505070154 / 275112497 : ℚ)) * X ^ 16 + C ((37547426027046 / 275112497 : ℚ)) * X ^ 17 + C ((41522268804532 / 825337491 : ℚ)) * X ^ 18
theorem UP4_pre_eq :
    UA_0_0_re * UP4_Fre - UA_0_0_im * UP4_Fim = UP4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP4_Fre, UP4_Fim, UP4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP4_pim_eq :
    UA_0_0_re * UP4_Fim + UA_0_0_im * UP4_Fre = UP4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP4_Fre, UP4_Fim, UP4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP4_mul : UA_0_0 * UP4_F = ofLadj UP4_pre UP4_pim := by
  rw [UA_0_0, UP4_F, ofLadj_mul, UP4_pre_eq, UP4_pim_eq]

def UP5_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def UP5_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def UP5_F : Ki := ofLadj UP5_Fre UP5_Fim
def UP5_pre : Polynomial ℚ := C ((3146594050096 / 825337491 : ℚ)) + C ((50864935549456 / 825337491 : ℚ)) * X + C ((9242155884994 / 75030681 : ℚ)) * X ^ 2 + C ((165079368938236 / 825337491 : ℚ)) * X ^ 3 + C ((250785034902367 / 825337491 : ℚ)) * X ^ 4 + C ((27565941700567 / 75030681 : ℚ)) * X ^ 5 + C ((31905077324236 / 75030681 : ℚ)) * X ^ 6 + C ((127611441868215 / 275112497 : ℚ)) * X ^ 7 + C ((376401806136322 / 825337491 : ℚ)) * X ^ 8 + C ((127150636059402 / 275112497 : ℚ)) * X ^ 9 + C ((385315098055138 / 825337491 : ℚ)) * X ^ 10 + C ((34872894939464 / 75030681 : ℚ)) * X ^ 11 + C ((111483387501894 / 275112497 : ℚ)) * X ^ 12 + C ((279788193443272 / 825337491 : ℚ)) * X ^ 13 + C ((70440812399362 / 275112497 : ℚ)) * X ^ 14 + C ((120970774159780 / 825337491 : ℚ)) * X ^ 15 + C ((65773612799236 / 825337491 : ℚ)) * X ^ 16 + C ((18043120938877 / 825337491 : ℚ)) * X ^ 17 + C ((-11078516542498 / 825337491 : ℚ)) * X ^ 18
def UP5_pim : Polynomial ℚ := C ((-12140137914106 / 275112497 : ℚ)) + C ((-24280275828212 / 275112497 : ℚ)) * X + C ((-88840336468732 / 825337491 : ℚ)) * X ^ 2 + C ((-110868889548592 / 825337491 : ℚ)) * X ^ 3 + C ((-96334866352573 / 825337491 : ℚ)) * X ^ 4 + C ((-57870355668193 / 825337491 : ℚ)) * X ^ 5 + C ((-28098796073569 / 825337491 : ℚ)) * X ^ 6 + C ((25447091388100 / 825337491 : ℚ)) * X ^ 7 + C ((56432733122606 / 825337491 : ℚ)) * X ^ 8 + C ((19052582192200 / 275112497 : ℚ)) * X ^ 9 + C ((60503339431229 / 825337491 : ℚ)) * X ^ 10 + C ((101819884084594 / 825337491 : ℚ)) * X ^ 11 + C ((47712142912653 / 275112497 : ℚ)) * X ^ 12 + C ((4923682744748 / 25010227 : ℚ)) * X ^ 13 + C ((185235097110538 / 825337491 : ℚ)) * X ^ 14 + C ((56194843081693 / 275112497 : ℚ)) * X ^ 15 + C ((41939909687721 / 275112497 : ℚ)) * X ^ 16 + C ((90948363363151 / 825337491 : ℚ)) * X ^ 17 + C ((3009289673086 / 75030681 : ℚ)) * X ^ 18
theorem UP5_pre_eq :
    UA_0_0_re * UP5_Fre - UA_0_0_im * UP5_Fim = UP5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP5_Fre, UP5_Fim, UP5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP5_pim_eq :
    UA_0_0_re * UP5_Fim + UA_0_0_im * UP5_Fre = UP5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_0_re, UA_0_0_im, UP5_Fre, UP5_Fim, UP5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP5_mul : UA_0_0 * UP5_F = ofLadj UP5_pre UP5_pim := by
  rw [UA_0_0, UP5_F, ofLadj_mul, UP5_pre_eq, UP5_pim_eq]

def UP6_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP6_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP6_F : Ki := ofLadj UP6_Fre UP6_Fim
def UP6_pre : Polynomial ℚ := C ((2473424439108 / 275112497 : ℚ)) + C ((-2246475480596 / 275112497 : ℚ)) * X ^ 2 + C ((-6343845336373 / 275112497 : ℚ)) * X ^ 3 + C ((-19444592862795 / 275112497 : ℚ)) * X ^ 4 + C ((-32643749160104 / 275112497 : ℚ)) * X ^ 5 + C ((-4199408344952 / 25010227 : ℚ)) * X ^ 6 + C ((-57230890541433 / 275112497 : ℚ)) * X ^ 7 + C ((-61411327264937 / 275112497 : ℚ)) * X ^ 8 + C ((-5745168023982 / 25010227 : ℚ)) * X ^ 9 + C ((-64551420629845 / 275112497 : ℚ)) * X ^ 10 + C ((-67538240836796 / 275112497 : ℚ)) * X ^ 11 + C ((-64551420629845 / 275112497 : ℚ)) * X ^ 12 + C ((-60950372783206 / 275112497 : ℚ)) * X ^ 13 + C ((-55067481928564 / 275112497 : ℚ)) * X ^ 14 + C ((-40332776500046 / 275112497 : ℚ)) * X ^ 15 + C ((-26159634147523 / 275112497 : ℚ)) * X ^ 16 + C ((-12609891513155 / 275112497 : ℚ)) * X ^ 17 + C ((-2546478821408 / 275112497 : ℚ)) * X ^ 18
def UP6_pim : Polynomial ℚ := C ((8504258482674 / 275112497 : ℚ)) + C ((17008516965348 / 275112497 : ℚ)) * X + C ((27674467211656 / 275112497 : ℚ)) * X ^ 2 + C ((42091312407659 / 275112497 : ℚ)) * X ^ 3 + C ((51047361046757 / 275112497 : ℚ)) * X ^ 4 + C ((55293914854284 / 275112497 : ℚ)) * X ^ 5 + C ((56438497951398 / 275112497 : ℚ)) * X ^ 6 + C ((48221176101433 / 275112497 : ℚ)) * X ^ 7 + C ((42849855117639 / 275112497 : ℚ)) * X ^ 8 + C ((42590186122072 / 275112497 : ℚ)) * X ^ 9 + C ((3764885722859 / 25010227 : ℚ)) * X ^ 10 + C ((2834752827558 / 25010227 : ℚ)) * X ^ 11 + C ((1904619932257 / 25010227 : ℚ)) * X ^ 12 + C ((828038712536 / 25010227 : ℚ)) * X ^ 13 + C ((-506189850334 / 25010227 : ℚ)) * X ^ 14 + C ((-13771452395672 / 275112497 : ℚ)) * X ^ 15 + C ((-1500921819613 / 25010227 : ℚ)) * X ^ 16 + C ((-15849193618315 / 275112497 : ℚ)) * X ^ 17 + C ((-6124005580894 / 275112497 : ℚ)) * X ^ 18
theorem UP6_pre_eq :
    UA_1_0_re * UP6_Fre - UA_1_0_im * UP6_Fim = UP6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP6_Fre, UP6_Fim, UP6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP6_pim_eq :
    UA_1_0_re * UP6_Fim + UA_1_0_im * UP6_Fre = UP6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP6_Fre, UP6_Fim, UP6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP6_mul : UA_1_0 * UP6_F = ofLadj UP6_pre UP6_pim := by
  rw [UA_1_0, UP6_F, ofLadj_mul, UP6_pre_eq, UP6_pim_eq]

def UP7_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def UP7_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def UP7_F : Ki := ofLadj UP7_Fre UP7_Fim
def UP7_pre : Polynomial ℚ := C ((203636072272 / 825337491 : ℚ)) + C ((-15118681746976 / 275112497 : ℚ)) * X + C ((-90916930571636 / 825337491 : ℚ)) * X ^ 2 + C ((-49355162190440 / 275112497 : ℚ)) * X ^ 3 + C ((-250117818645272 / 825337491 : ℚ)) * X ^ 4 + C ((-106789429521204 / 275112497 : ℚ)) * X ^ 5 + C ((-386140726065700 / 825337491 : ℚ)) * X ^ 6 + C ((-138317058742812 / 275112497 : ℚ)) * X ^ 7 + C ((-128771169741880 / 275112497 : ℚ)) * X ^ 8 + C ((-121898772335228 / 275112497 : ℚ)) * X ^ 9 + C ((-350115551555248 / 825337491 : ℚ)) * X ^ 10 + C ((-344370621716984 / 825337491 : ℚ)) * X ^ 11 + C ((-304759506314320 / 825337491 : ℚ)) * X ^ 12 + C ((-274779386434048 / 825337491 : ℚ)) * X ^ 13 + C ((-79416007551440 / 275112497 : ℚ)) * X ^ 14 + C ((-155010035834704 / 825337491 : ℚ)) * X ^ 15 + C ((-32002197529744 / 275112497 : ℚ)) * X ^ 16 + C ((-30234155087144 / 825337491 : ℚ)) * X ^ 17 + C ((27061492420 / 2273657 : ℚ)) * X ^ 18
def UP7_pim : Polynomial ℚ := C ((3907676257996 / 75030681 : ℚ)) + C ((7815352515992 / 75030681 : ℚ)) * X + C ((3371952026028 / 25010227 : ℚ)) * X ^ 2 + C ((152409792016544 / 825337491 : ℚ)) * X ^ 3 + C ((51147499329236 / 275112497 : ℚ)) * X ^ 4 + C ((112575280255520 / 825337491 : ℚ)) * X ^ 5 + C ((67304597642192 / 825337491 : ℚ)) * X ^ 6 + C ((-6413615306832 / 275112497 : ℚ)) * X ^ 7 + C ((-66512337261968 / 825337491 : ℚ)) * X ^ 8 + C ((-63488928518080 / 825337491 : ℚ)) * X ^ 9 + C ((-49946475775996 / 825337491 : ℚ)) * X ^ 10 + C ((-73010350284104 / 825337491 : ℚ)) * X ^ 11 + C ((-32024741597404 / 275112497 : ℚ)) * X ^ 12 + C ((-107837311233140 / 825337491 : ℚ)) * X ^ 13 + C ((-48649759215624 / 275112497 : ℚ)) * X ^ 14 + C ((-51896974804716 / 275112497 : ℚ)) * X ^ 15 + C ((-132174688256624 / 825337491 : ℚ)) * X ^ 16 + C ((-107757012533384 / 825337491 : ℚ)) * X ^ 17 + C ((-12854183515120 / 275112497 : ℚ)) * X ^ 18
theorem UP7_pre_eq :
    UA_1_0_re * UP7_Fre - UA_1_0_im * UP7_Fim = UP7_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP7_Fre, UP7_Fim, UP7_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP7_pim_eq :
    UA_1_0_re * UP7_Fim + UA_1_0_im * UP7_Fre = UP7_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP7_Fre, UP7_Fim, UP7_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP7_mul : UA_1_0 * UP7_F = ofLadj UP7_pre UP7_pim := by
  rw [UA_1_0, UP7_F, ofLadj_mul, UP7_pre_eq, UP7_pim_eq]

def UP8_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def UP8_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def UP8_F : Ki := ofLadj UP8_Fre UP8_Fim
def UP8_pre : Polynomial ℚ := C ((8522883242688 / 275112497 : ℚ)) + C ((60474726987904 / 275112497 : ℚ)) * X + C ((342385687846216 / 825337491 : ℚ)) * X ^ 2 + C ((179480212597340 / 275112497 : ℚ)) * X ^ 3 + C ((255401528844328 / 275112497 : ℚ)) * X ^ 4 + C ((878787396193204 / 825337491 : ℚ)) * X ^ 5 + C ((961536030677680 / 825337491 : ℚ)) * X ^ 6 + C ((333506213737676 / 275112497 : ℚ)) * X ^ 7 + C ((28083182954404 / 25010227 : ℚ)) * X ^ 8 + C ((304226190846268 / 275112497 : ℚ)) * X ^ 9 + C ((901976683050748 / 825337491 : ℚ)) * X ^ 10 + C ((872381584048112 / 825337491 : ℚ)) * X ^ 11 + C ((720552502087036 / 825337491 : ℚ)) * X ^ 12 + C ((570292884692588 / 825337491 : ℚ)) * X ^ 13 + C ((129434799901104 / 275112497 : ℚ)) * X ^ 14 + C ((173436592408276 / 825337491 : ℚ)) * X ^ 15 + C ((68535657302852 / 825337491 : ℚ)) * X ^ 16 + C ((-14212977181624 / 825337491 : ℚ)) * X ^ 17 + C ((-60877462271768 / 825337491 : ℚ)) * X ^ 18
def UP8_pim : Polynomial ℚ := C ((-81225664869968 / 825337491 : ℚ)) + C ((-162451329739936 / 825337491 : ℚ)) * X + C ((-51594106899608 / 275112497 : ℚ)) * X ^ 2 + C ((-153655478053016 / 825337491 : ℚ)) * X ^ 3 + C ((-13883237848344 / 275112497 : ℚ)) * X ^ 4 + C ((132823859097964 / 825337491 : ℚ)) * X ^ 5 + C ((266358209263132 / 825337491 : ℚ)) * X ^ 6 + C ((436129608625204 / 825337491 : ℚ)) * X ^ 7 + C ((16077884335300 / 25010227 : ℚ)) * X ^ 8 + C ((48048740183200 / 75030681 : ℚ)) * X ^ 9 + C ((519251814597128 / 825337491 : ℚ)) * X ^ 10 + C ((586855695202448 / 825337491 : ℚ)) * X ^ 11 + C ((654459575807768 / 825337491 : ℚ)) * X ^ 12 + C ((637506239348584 / 825337491 : ℚ)) * X ^ 13 + C ((634345355653076 / 825337491 : ℚ)) * X ^ 14 + C ((528256804501772 / 825337491 : ℚ)) * X ^ 15 + C ((365695359233324 / 825337491 : ℚ)) * X ^ 16 + C ((246382633070540 / 825337491 : ℚ)) * X ^ 17 + C ((29507787027672 / 275112497 : ℚ)) * X ^ 18
theorem UP8_pre_eq :
    UA_1_0_re * UP8_Fre - UA_1_0_im * UP8_Fim = UP8_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP8_Fre, UP8_Fim, UP8_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP8_pim_eq :
    UA_1_0_re * UP8_Fim + UA_1_0_im * UP8_Fre = UP8_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP8_Fre, UP8_Fim, UP8_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP8_mul : UA_1_0 * UP8_F = ofLadj UP8_pre UP8_pim := by
  rw [UA_1_0, UP8_F, ofLadj_mul, UP8_pre_eq, UP8_pim_eq]

def UP9_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def UP9_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def UP9_F : Ki := ofLadj UP9_Fre UP9_Fim
def UP9_pre : Polynomial ℚ := C ((-157692316178 / 825337491 : ℚ)) + C ((-18898352183720 / 275112497 : ℚ)) * X + C ((-3261470516122 / 25010227 : ℚ)) * X ^ 2 + C ((-185153961107840 / 825337491 : ℚ)) * X ^ 3 + C ((-27454715819276 / 75030681 : ℚ)) * X ^ 4 + C ((-35444494908808 / 75030681 : ℚ)) * X ^ 5 + C ((-14394571930506 / 25010227 : ℚ)) * X ^ 6 + C ((-181344038249256 / 275112497 : ℚ)) * X ^ 7 + C ((-184363050098762 / 275112497 : ℚ)) * X ^ 8 + C ((-572474300092768 / 825337491 : ℚ)) * X ^ 9 + C ((-587096380281568 / 825337491 : ℚ)) * X ^ 10 + C ((-592546085678500 / 825337491 : ℚ)) * X ^ 11 + C ((-530401323730408 / 825337491 : ℚ)) * X ^ 12 + C ((-464845773060742 / 825337491 : ℚ)) * X ^ 13 + C ((-33448653562586 / 75030681 : ℚ)) * X ^ 14 + C ((-77806421231312 / 275112497 : ℚ)) * X ^ 15 + C ((-134963349646798 / 825337491 : ℚ)) * X ^ 16 + C ((-16610639978996 / 275112497 : ℚ)) * X ^ 17 + C ((8610977041796 / 825337491 : ℚ)) * X ^ 18
def UP9_pim : Polynomial ℚ := C ((52313172133666 / 825337491 : ℚ)) + C ((104626344267332 / 825337491 : ℚ)) * X + C ((141550522267918 / 825337491 : ℚ)) * X ^ 2 + C ((66160706403516 / 275112497 : ℚ)) * X ^ 3 + C ((69322855651900 / 275112497 : ℚ)) * X ^ 4 + C ((16788904789520 / 75030681 : ℚ)) * X ^ 5 + C ((53982012433390 / 275112497 : ℚ)) * X ^ 6 + C ((96295567372252 / 825337491 : ℚ)) * X ^ 7 + C ((16399452056738 / 275112497 : ℚ)) * X ^ 8 + C ((46346489258812 / 825337491 : ℚ)) * X ^ 9 + C ((3057166053784 / 75030681 : ℚ)) * X ^ 10 + C ((-37402634131528 / 825337491 : ℚ)) * X ^ 11 + C ((-108434094854680 / 825337491 : ℚ)) * X ^ 12 + C ((-158075935522454 / 825337491 : ℚ)) * X ^ 13 + C ((-72619799792162 / 275112497 : ℚ)) * X ^ 14 + C ((-73048570442348 / 275112497 : ℚ)) * X ^ 15 + C ((-179570668590482 / 825337491 : ℚ)) * X ^ 16 + C ((-137232245390132 / 825337491 : ℚ)) * X ^ 17 + C ((-55297346996632 / 825337491 : ℚ)) * X ^ 18
theorem UP9_pre_eq :
    UA_1_0_re * UP9_Fre - UA_1_0_im * UP9_Fim = UP9_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP9_Fre, UP9_Fim, UP9_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP9_pim_eq :
    UA_1_0_re * UP9_Fim + UA_1_0_im * UP9_Fre = UP9_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP9_Fre, UP9_Fim, UP9_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP9_mul : UA_1_0 * UP9_F = ofLadj UP9_pre UP9_pim := by
  rw [UA_1_0, UP9_F, ofLadj_mul, UP9_pre_eq, UP9_pim_eq]

def UP10_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP10_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP10_F : Ki := ofLadj UP10_Fre UP10_Fim
def UP10_pre : Polynomial ℚ := C ((-5706755175144 / 275112497 : ℚ)) + C ((-75593408734880 / 275112497 : ℚ)) * X + C ((-462128707297288 / 825337491 : ℚ)) * X ^ 2 + C ((-759174912150592 / 825337491 : ℚ)) * X ^ 3 + C ((-1129830466978096 / 825337491 : ℚ)) * X ^ 4 + C ((-1343319870805556 / 825337491 : ℚ)) * X ^ 5 + C ((-1514054163422572 / 825337491 : ℚ)) * X ^ 6 + C ((-1608634361022916 / 825337491 : ℚ)) * X ^ 7 + C ((-1532529253852444 / 825337491 : ℚ)) * X ^ 8 + C ((-45563279586404 / 25010227 : ℚ)) * X ^ 9 + C ((-1481451493696004 / 825337491 : ℚ)) * X ^ 10 + C ((-485370236658712 / 275112497 : ℚ)) * X ^ 11 + C ((-1254671267491364 / 825337491 : ℚ)) * X ^ 12 + C ((-1041459519054044 / 825337491 : ℚ)) * X ^ 13 + C ((-257784780567284 / 275112497 : ℚ)) * X ^ 14 + C ((-429324691765348 / 825337491 : ℚ)) * X ^ 15 + C ((-231651603980672 / 825337491 : ℚ)) * X ^ 16 + C ((-1845979132232 / 25010227 : ℚ)) * X ^ 17 + C ((49479202279472 / 825337491 : ℚ)) * X ^ 18
def UP10_pim : Polynomial ℚ := C ((13868875634864 / 75030681 : ℚ)) + C ((27737751269728 / 75030681 : ℚ)) * X + C ((362461275007160 / 825337491 : ℚ)) * X ^ 2 + C ((426010664438872 / 825337491 : ℚ)) * X ^ 3 + C ((320858983437656 / 825337491 : ℚ)) * X ^ 4 + C ((110915873533444 / 825337491 : ℚ)) * X ^ 5 + C ((-19011648431068 / 275112497 : ℚ)) * X ^ 6 + C ((-27583604519324 / 75030681 : ℚ)) * X ^ 7 + C ((-445305722659396 / 825337491 : ℚ)) * X ^ 8 + C ((-441159940363820 / 825337491 : ℚ)) * X ^ 9 + C ((-421991015785684 / 825337491 : ℚ)) * X ^ 10 + C ((-546475932384232 / 825337491 : ℚ)) * X ^ 11 + C ((-670960848982780 / 825337491 : ℚ)) * X ^ 12 + C ((-21489028346812 / 25010227 : ℚ)) * X ^ 13 + C ((-256180514193644 / 275112497 : ℚ)) * X ^ 14 + C ((-61411068606244 / 75030681 : ℚ)) * X ^ 15 + C ((-44564988861760 / 75030681 : ℚ)) * X ^ 16 + C ((-351502651562336 / 825337491 : ℚ)) * X ^ 17 + C ((-129754179857864 / 825337491 : ℚ)) * X ^ 18
theorem UP10_pre_eq :
    UA_1_0_re * UP10_Fre - UA_1_0_im * UP10_Fim = UP10_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP10_Fre, UP10_Fim, UP10_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP10_pim_eq :
    UA_1_0_re * UP10_Fim + UA_1_0_im * UP10_Fre = UP10_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP10_Fre, UP10_Fim, UP10_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP10_mul : UA_1_0 * UP10_F = ofLadj UP10_pre UP10_pim := by
  rw [UA_1_0, UP10_F, ofLadj_mul, UP10_pre_eq, UP10_pim_eq]

def UP11_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def UP11_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def UP11_F : Ki := ofLadj UP11_Fre UP11_Fim
def UP11_pre : Polynomial ℚ := C ((-3335148772172 / 275112497 : ℚ)) + C ((-52915386114416 / 275112497 : ℚ)) * X + C ((-28863136266436 / 75030681 : ℚ)) * X ^ 2 + C ((-171771573891174 / 275112497 : ℚ)) * X ^ 3 + C ((-782670691088246 / 825337491 : ℚ)) * X ^ 4 + C ((-315540954221542 / 275112497 : ℚ)) * X ^ 5 + C ((-1095335052815518 / 825337491 : ℚ)) * X ^ 6 + C ((-1195005934809772 / 825337491 : ℚ)) * X ^ 7 + C ((-1174951723633108 / 825337491 : ℚ)) * X ^ 8 + C ((-1190694383303782 / 825337491 : ℚ)) * X ^ 9 + C ((-1202765084848364 / 825337491 : ℚ)) * X ^ 10 + C ((-399071758626412 / 275112497 : ℚ)) * X ^ 11 + C ((-1044018926505116 / 825337491 : ℚ)) * X ^ 12 + C ((-873199884372986 / 825337491 : ℚ)) * X ^ 13 + C ((-659637001959586 / 825337491 : ℚ)) * X ^ 14 + C ((-377772320833330 / 825337491 : ℚ)) * X ^ 15 + C ((-205221301807046 / 825337491 : ℚ)) * X ^ 16 + C ((-56509111656154 / 825337491 : ℚ)) * X ^ 17 + C ((34562922888196 / 825337491 : ℚ)) * X ^ 18
def UP11_pim : Polynomial ℚ := C ((113593749174592 / 825337491 : ℚ)) + C ((227187498349184 / 825337491 : ℚ)) * X + C ((277285430116120 / 825337491 : ℚ)) * X ^ 2 + C ((345704125638686 / 825337491 : ℚ)) * X ^ 3 + C ((300622838744918 / 825337491 : ℚ)) * X ^ 4 + C ((60128725539242 / 275112497 : ℚ)) * X ^ 5 + C ((29150661937402 / 275112497 : ℚ)) * X ^ 6 + C ((-79485041692516 / 825337491 : ℚ)) * X ^ 7 + C ((-16030514537320 / 75030681 : ℚ)) * X ^ 8 + C ((-16234781785978 / 75030681 : ℚ)) * X ^ 9 + C ((-189029336003104 / 825337491 : ℚ)) * X ^ 10 + C ((-317900788200640 / 825337491 : ℚ)) * X ^ 11 + C ((-40615658218016 / 75030681 : ℚ)) * X ^ 12 + C ((-507316908522458 / 825337491 : ℚ)) * X ^ 13 + C ((-192660847926754 / 275112497 : ℚ)) * X ^ 14 + C ((-175437411543402 / 275112497 : ℚ)) * X ^ 15 + C ((-392640815990810 / 825337491 : ℚ)) * X ^ 16 + C ((-283811424491218 / 825337491 : ℚ)) * X ^ 17 + C ((-103439640474292 / 825337491 : ℚ)) * X ^ 18
theorem UP11_pre_eq :
    UA_1_0_re * UP11_Fre - UA_1_0_im * UP11_Fim = UP11_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP11_Fre, UP11_Fim, UP11_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP11_pim_eq :
    UA_1_0_re * UP11_Fim + UA_1_0_im * UP11_Fre = UP11_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_0_re, UA_1_0_im, UP11_Fre, UP11_Fim, UP11_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP11_mul : UA_1_0 * UP11_F = ofLadj UP11_pre UP11_pim := by
  rw [UA_1_0, UP11_F, ofLadj_mul, UP11_pre_eq, UP11_pim_eq]

def UP12_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP12_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP12_F : Ki := ofLadj UP12_Fre UP12_Fim
def UP12_pre : Polynomial ℚ := C ((-41060553450 / 275112497 : ℚ)) + C ((27454172508 / 275112497 : ℚ)) * X ^ 2 + C ((90504375167 / 275112497 : ℚ)) * X ^ 3 + C ((293881436017 / 275112497 : ℚ)) * X ^ 4 + C ((497885661392 / 275112497 : ℚ)) * X ^ 5 + C ((710836648424 / 275112497 : ℚ)) * X ^ 6 + C ((879537096838 / 275112497 : ℚ)) * X ^ 7 + C ((942215870205 / 275112497 : ℚ)) * X ^ 8 + C ((88126978233 / 25010227 : ℚ)) * X ^ 9 + C ((991186886313 / 275112497 : ℚ)) * X ^ 10 + C ((94492706714 / 25010227 : ℚ)) * X ^ 11 + C ((991186886313 / 275112497 : ℚ)) * X ^ 12 + C ((941942588055 / 275112497 : ℚ)) * X ^ 13 + C ((851711495038 / 275112497 : ℚ)) * X ^ 14 + C ((622753759559 / 275112497 : ℚ)) * X ^ 15 + C ((403662799123 / 275112497 : ℚ)) * X ^ 16 + C ((190711812091 / 275112497 : ℚ)) * X ^ 17 + C ((37098098738 / 275112497 : ℚ)) * X ^ 18
def UP12_pim : Polynomial ℚ := C ((-134803472424 / 275112497 : ℚ)) + C ((-269606944848 / 275112497 : ℚ)) * X + C ((-434019510332 / 275112497 : ℚ)) * X ^ 2 + C ((-662108429907 / 275112497 : ℚ)) * X ^ 3 + C ((-797274833919 / 275112497 : ℚ)) * X ^ 4 + C ((-865067822770 / 275112497 : ℚ)) * X ^ 5 + C ((-883316454874 / 275112497 : ℚ)) * X ^ 6 + C ((-68988985288 / 25010227 : ℚ)) * X ^ 7 + C ((-61628698919 / 25010227 : ℚ)) * X ^ 8 + C ((-674379304277 / 275112497 : ℚ)) * X ^ 9 + C ((-656009584641 / 275112497 : ℚ)) * X ^ 10 + C ((-44934490808 / 25010227 : ℚ)) * X ^ 11 + C ((-332549213135 / 275112497 : ℚ)) * X ^ 12 + C ((-149766928015 / 275112497 : ℚ)) * X ^ 13 + C ((81858375392 / 275112497 : ℚ)) * X ^ 14 + C ((18719410689 / 25010227 : ℚ)) * X ^ 15 + C ((249533054627 / 275112497 : ℚ)) * X ^ 16 + C ((240685480393 / 275112497 : ℚ)) * X ^ 17 + C ((92074411884 / 275112497 : ℚ)) * X ^ 18
theorem UP12_pre_eq :
    UA_0_1_re * UP12_Fre - UA_0_1_im * UP12_Fim = UP12_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP12_Fre, UP12_Fim, UP12_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP12_pim_eq :
    UA_0_1_re * UP12_Fim + UA_0_1_im * UP12_Fre = UP12_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP12_Fre, UP12_Fim, UP12_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP12_mul : UA_0_1 * UP12_F = ofLadj UP12_pre UP12_pim := by
  rw [UA_0_1, UP12_F, ofLadj_mul, UP12_pre_eq, UP12_pim_eq]

def UP13_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def UP13_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def UP13_F : Ki := ofLadj UP13_Fre UP13_Fim
def UP13_pre : Polynomial ℚ := C ((-11877952868 / 825337491 : ℚ)) + C ((718951852928 / 825337491 : ℚ)) * X + C ((1399766995492 / 825337491 : ℚ)) * X ^ 2 + C ((207411006896 / 75030681 : ℚ)) * X ^ 3 + C ((3883228614568 / 825337491 : ℚ)) * X ^ 4 + C ((1653143701760 / 275112497 : ℚ)) * X ^ 5 + C ((6005545264852 / 825337491 : ℚ)) * X ^ 6 + C ((6439198913336 / 825337491 : ℚ)) * X ^ 7 + C ((1995463122788 / 275112497 : ℚ)) * X ^ 8 + C ((172025813136 / 25010227 : ℚ)) * X ^ 9 + C ((1807572757712 / 275112497 : ℚ)) * X ^ 10 + C ((1784931857880 / 275112497 : ℚ)) * X ^ 11 + C ((4703766420208 / 825337491 : ℚ)) * X ^ 12 + C ((4277084837996 / 825337491 : ℚ)) * X ^ 13 + C ((3704868292508 / 825337491 : ℚ)) * X ^ 14 + C ((2402573289928 / 825337491 : ℚ)) * X ^ 15 + C ((1497884154364 / 825337491 : ℚ)) * X ^ 16 + C ((150589998264 / 275112497 : ℚ)) * X ^ 17 + C ((-51132336280 / 275112497 : ℚ)) * X ^ 18
def UP13_pim : Polynomial ℚ := C ((-227943425304 / 275112497 : ℚ)) + C ((-455886850608 / 275112497 : ℚ)) * X + C ((-1751750825468 / 825337491 : ℚ)) * X ^ 2 + C ((-2427070357256 / 825337491 : ℚ)) * X ^ 3 + C ((-808465529248 / 275112497 : ℚ)) * X ^ 4 + C ((-598811092144 / 275112497 : ℚ)) * X ^ 5 + C ((-1108294640720 / 825337491 : ℚ)) * X ^ 6 + C ((239348162428 / 825337491 : ℚ)) * X ^ 7 + C ((937995416972 / 825337491 : ℚ)) * X ^ 8 + C ((299834198216 / 275112497 : ℚ)) * X ^ 9 + C ((228002220288 / 275112497 : ℚ)) * X ^ 10 + C ((353526656992 / 275112497 : ℚ)) * X ^ 11 + C ((479051093696 / 275112497 : ℚ)) * X ^ 12 + C ((1605747620948 / 825337491 : ℚ)) * X ^ 13 + C ((747524776804 / 275112497 : ℚ)) * X ^ 14 + C ((2364037482944 / 825337491 : ℚ)) * X ^ 15 + C ((672401557480 / 275112497 : ℚ)) * X ^ 16 + C ((1641022634840 / 825337491 : ℚ)) * X ^ 17 + C ((191836777500 / 275112497 : ℚ)) * X ^ 18
theorem UP13_pre_eq :
    UA_0_1_re * UP13_Fre - UA_0_1_im * UP13_Fim = UP13_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP13_Fre, UP13_Fim, UP13_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP13_pim_eq :
    UA_0_1_re * UP13_Fim + UA_0_1_im * UP13_Fre = UP13_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP13_Fre, UP13_Fim, UP13_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP13_mul : UA_0_1 * UP13_F = ofLadj UP13_pre UP13_pim := by
  rw [UA_0_1, UP13_F, ofLadj_mul, UP13_pre_eq, UP13_pim_eq]

def UP14_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def UP14_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def UP14_F : Ki := ofLadj UP14_Fre UP14_Fim
def UP14_pre : Polynomial ℚ := C ((-390467425328 / 825337491 : ℚ)) + C ((-2875807411712 / 825337491 : ℚ)) * X + C ((-5347886994760 / 825337491 : ℚ)) * X ^ 2 + C ((-8383482477136 / 825337491 : ℚ)) * X ^ 3 + C ((-3988643997192 / 275112497 : ℚ)) * X ^ 4 + C ((-4554609119052 / 275112497 : ℚ)) * X ^ 5 + C ((-15023065999972 / 825337491 : ℚ)) * X ^ 6 + C ((-15599395984580 / 825337491 : ℚ)) * X ^ 7 + C ((-14472371008984 / 825337491 : ℚ)) * X ^ 8 + C ((-14255284321132 / 825337491 : ℚ)) * X ^ 9 + C ((-14085848056844 / 825337491 : ℚ)) * X ^ 10 + C ((-13636863460168 / 825337491 : ℚ)) * X ^ 11 + C ((-3736680215044 / 275112497 : ℚ)) * X ^ 12 + C ((-2969132442124 / 275112497 : ℚ)) * X ^ 13 + C ((-2029629510616 / 275112497 : ℚ)) * X ^ 14 + C ((-2707715260276 / 825337491 : ℚ)) * X ^ 15 + C ((-1127345606564 / 825337491 : ℚ)) * X ^ 16 + C ((231893036252 / 825337491 : ℚ)) * X ^ 17 + C ((925748732728 / 825337491 : ℚ)) * X ^ 18
def UP14_pim : Polynomial ℚ := C ((1297417397792 / 825337491 : ℚ)) + C ((2594834795584 / 825337491 : ℚ)) * X + C ((2455623647608 / 825337491 : ℚ)) * X ^ 2 + C ((230462797148 / 75030681 : ℚ)) * X ^ 3 + C ((751805052176 / 825337491 : ℚ)) * X ^ 4 + C ((-640031215412 / 275112497 : ℚ)) * X ^ 5 + C ((-3966317912384 / 825337491 : ℚ)) * X ^ 6 + C ((-2200124033728 / 275112497 : ℚ)) * X ^ 7 + C ((-8004855145940 / 825337491 : ℚ)) * X ^ 8 + C ((-7974307534904 / 825337491 : ℚ)) * X ^ 9 + C ((-7828535254780 / 825337491 : ℚ)) * X ^ 10 + C ((-8915506927936 / 825337491 : ℚ)) * X ^ 11 + C ((-10002478601092 / 825337491 : ℚ)) * X ^ 12 + C ((-3239165057664 / 275112497 : ℚ)) * X ^ 13 + C ((-3255471560992 / 275112497 : ℚ)) * X ^ 14 + C ((-8072823043864 / 825337491 : ℚ)) * X ^ 15 + C ((-1863231796620 / 275112497 : ℚ)) * X ^ 16 + C ((-3760072111808 / 825337491 : ℚ)) * X ^ 17 + C ((-1314788967416 / 825337491 : ℚ)) * X ^ 18
theorem UP14_pre_eq :
    UA_0_1_re * UP14_Fre - UA_0_1_im * UP14_Fim = UP14_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP14_Fre, UP14_Fim, UP14_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP14_pim_eq :
    UA_0_1_re * UP14_Fim + UA_0_1_im * UP14_Fre = UP14_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP14_Fre, UP14_Fim, UP14_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP14_mul : UA_0_1 * UP14_F = ofLadj UP14_pre UP14_pim := by
  rw [UA_0_1, UP14_F, ofLadj_mul, UP14_pre_eq, UP14_pim_eq]

def UP15_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def UP15_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def UP15_F : Ki := ofLadj UP15_Fre UP15_Fim
def UP15_pre : Polynomial ℚ := C ((-2668005170 / 275112497 : ℚ)) + C ((898689816160 / 825337491 : ℚ)) * X + C ((551310021582 / 275112497 : ℚ)) * X ^ 2 + C ((2855389245272 / 825337491 : ℚ)) * X ^ 3 + C ((1560099313270 / 275112497 : ℚ)) * X ^ 4 + C ((6025120919842 / 825337491 : ℚ)) * X ^ 5 + C ((2458582272980 / 275112497 : ℚ)) * X ^ 6 + C ((8425144527574 / 825337491 : ℚ)) * X ^ 7 + C ((8568381065020 / 825337491 : ℚ)) * X ^ 8 + C ((8857014829294 / 825337491 : ℚ)) * X ^ 9 + C ((9098856679226 / 825337491 : ℚ)) * X ^ 10 + C ((9180945751280 / 825337491 : ℚ)) * X ^ 11 + C ((8200166863066 / 825337491 : ℚ)) * X ^ 12 + C ((7203084764548 / 825337491 : ℚ)) * X ^ 13 + C ((5712991819748 / 825337491 : ℚ)) * X ^ 14 + C ((3606825486388 / 825337491 : ℚ)) * X ^ 15 + C ((2100773773886 / 825337491 : ℚ)) * X ^ 16 + C ((250049291596 / 275112497 : ℚ)) * X ^ 17 + C ((-46007033792 / 275112497 : ℚ)) * X ^ 18
def UP15_pim : Polynomial ℚ := C ((-832320599486 / 825337491 : ℚ)) + C ((-1664641198972 / 825337491 : ℚ)) * X + C ((-2228698344394 / 825337491 : ℚ)) * X ^ 2 + C ((-1054170949356 / 275112497 : ℚ)) * X ^ 3 + C ((-1093372948386 / 275112497 : ℚ)) * X ^ 4 + C ((-2945255236310 / 825337491 : ℚ)) * X ^ 5 + C ((-866170345316 / 275112497 : ℚ)) * X ^ 6 + C ((-1599011612534 / 825337491 : ℚ)) * X ^ 7 + C ((-886264605356 / 825337491 : ℚ)) * X ^ 8 + C ((-852112150618 / 825337491 : ℚ)) * X ^ 9 + C ((-216681068566 / 275112497 : ℚ)) * X ^ 10 + C ((471969638368 / 825337491 : ℚ)) * X ^ 11 + C ((1593982482434 / 825337491 : ℚ)) * X ^ 12 + C ((786702857592 / 275112497 : ℚ)) * X ^ 13 + C ((1109358510396 / 275112497 : ℚ)) * X ^ 14 + C ((3332261135444 / 825337491 : ℚ)) * X ^ 15 + C ((2730625068322 / 825337491 : ℚ)) * X ^ 16 + C ((2092439281700 / 825337491 : ℚ)) * X ^ 17 + C ((826167400012 / 825337491 : ℚ)) * X ^ 18
theorem UP15_pre_eq :
    UA_0_1_re * UP15_Fre - UA_0_1_im * UP15_Fim = UP15_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP15_Fre, UP15_Fim, UP15_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP15_pim_eq :
    UA_0_1_re * UP15_Fim + UA_0_1_im * UP15_Fre = UP15_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP15_Fre, UP15_Fim, UP15_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP15_mul : UA_0_1 * UP15_F = ofLadj UP15_pre UP15_pim := by
  rw [UA_0_1, UP15_F, ofLadj_mul, UP15_pre_eq, UP15_pim_eq]

def UP16_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP16_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP16_F : Ki := ofLadj UP16_Fre UP16_Fim
def UP16_pre : Polynomial ℚ := C ((241720960960 / 825337491 : ℚ)) + C ((3594759264640 / 825337491 : ℚ)) * X + C ((2392604021768 / 275112497 : ℚ)) * X ^ 2 + C ((11787298210696 / 825337491 : ℚ)) * X ^ 3 + C ((5862924195576 / 275112497 : ℚ)) * X ^ 4 + C ((20843954124332 / 825337491 : ℚ)) * X ^ 5 + C ((23584851730300 / 825337491 : ℚ)) * X ^ 6 + C ((206663008660 / 6820971 : ℚ)) * X ^ 7 + C ((7944016341028 / 275112497 : ℚ)) * X ^ 8 + C ((23378608434400 / 825337491 : ℚ)) * X ^ 9 + C ((23038257878660 / 825337491 : ℚ)) * X ^ 10 + C ((7555709035192 / 275112497 : ℚ)) * X ^ 11 + C ((19443498614020 / 825337491 : ℚ)) * X ^ 12 + C ((16200796369096 / 825337491 : ℚ)) * X ^ 13 + C ((12044750812388 / 825337491 : ℚ)) * X ^ 14 + C ((6655471030820 / 825337491 : ℚ)) * X ^ 15 + C ((3644425895552 / 825337491 : ℚ)) * X ^ 16 + C ((301176096528 / 275112497 : ℚ)) * X ^ 17 + C ((-761980430312 / 825337491 : ℚ)) * X ^ 18
def UP16_pim : Polynomial ℚ := C ((-2430592581784 / 825337491 : ℚ)) + C ((-4861185163568 / 825337491 : ℚ)) * X + C ((-5724520088744 / 825337491 : ℚ)) * X ^ 2 + C ((-207500087312 / 25010227 : ℚ)) * X ^ 3 + C ((-5146674884968 / 825337491 : ℚ)) * X ^ 4 + C ((-1952688444332 / 825337491 : ℚ)) * X ^ 5 + C ((56126972948 / 75030681 : ℚ)) * X ^ 6 + C ((4421986334756 / 825337491 : ℚ)) * X ^ 7 + C ((6548402798644 / 825337491 : ℚ)) * X ^ 8 + C ((2160415616512 / 275112497 : ℚ)) * X ^ 9 + C ((6183057205340 / 825337491 : ℚ)) * X ^ 10 + C ((8178707266592 / 825337491 : ℚ)) * X ^ 11 + C ((10174357327844 / 825337491 : ℚ)) * X ^ 12 + C ((976318418984 / 75030681 : ℚ)) * X ^ 13 + C ((11795329452268 / 825337491 : ℚ)) * X ^ 14 + C ((10287174237364 / 825337491 : ℚ)) * X ^ 15 + C ((2491047202504 / 275112497 : ℚ)) * X ^ 16 + C ((1786126501336 / 275112497 : ℚ)) * X ^ 17 + C ((58598293408 / 25010227 : ℚ)) * X ^ 18
theorem UP16_pre_eq :
    UA_0_1_re * UP16_Fre - UA_0_1_im * UP16_Fim = UP16_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP16_Fre, UP16_Fim, UP16_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP16_pim_eq :
    UA_0_1_re * UP16_Fim + UA_0_1_im * UP16_Fre = UP16_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP16_Fre, UP16_Fim, UP16_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP16_mul : UA_0_1 * UP16_F = ofLadj UP16_pre UP16_pim := by
  rw [UA_0_1, UP16_F, ofLadj_mul, UP16_pre_eq, UP16_pim_eq]

def UP17_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def UP17_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def UP17_F : Ki := ofLadj UP17_Fre UP17_Fim
def UP17_pre : Polynomial ℚ := C ((136356229912 / 825337491 : ℚ)) + C ((2516331485248 / 825337491 : ℚ)) * X + C ((1640721594800 / 275112497 : ℚ)) * X ^ 2 + C ((7985884054838 / 825337491 : ℚ)) * X ^ 3 + C ((12170364474626 / 825337491 : ℚ)) * X ^ 4 + C ((4889927225366 / 275112497 : ℚ)) * X ^ 5 + C ((5681921561994 / 275112497 : ℚ)) * X ^ 6 + C ((18557659018106 / 825337491 : ℚ)) * X ^ 7 + C ((18246836698828 / 825337491 : ℚ)) * X ^ 8 + C ((6164518324282 / 275112497 : ℚ)) * X ^ 9 + C ((18676393958320 / 825337491 : ℚ)) * X ^ 10 + C ((18613194034232 / 825337491 : ℚ)) * X ^ 11 + C ((5386687491024 / 275112497 : ℚ)) * X ^ 12 + C ((4523796729482 / 275112497 : ℚ)) * X ^ 13 + C ((10260952643990 / 825337491 : ℚ)) * X ^ 14 + C ((5852907319484 / 825337491 : ℚ)) * X ^ 15 + C ((3216852882590 / 825337491 : ℚ)) * X ^ 16 + C ((840869872706 / 825337491 : ℚ)) * X ^ 17 + C ((-534387223996 / 825337491 : ℚ)) * X ^ 18
def UP17_pim : Polynomial ℚ := C ((-1809257585188 / 825337491 : ℚ)) + C ((-3618515170376 / 825337491 : ℚ)) * X + C ((-1458484205532 / 275112497 : ℚ)) * X ^ 2 + C ((-1846982893042 / 275112497 : ℚ)) * X ^ 3 + C ((-435605947078 / 75030681 : ℚ)) * X ^ 4 + C ((-2968617692086 / 825337491 : ℚ)) * X ^ 5 + C ((-519269021002 / 275112497 : ℚ)) * X ^ 6 + C ((30904838826 / 25010227 : ℚ)) * X ^ 7 + C ((223283611636 / 75030681 : ℚ)) * X ^ 8 + C ((830744015674 / 275112497 : ℚ)) * X ^ 9 + C ((2651747852992 / 825337491 : ℚ)) * X ^ 10 + C ((4700588696192 / 825337491 : ℚ)) * X ^ 11 + C ((2249809846464 / 275112497 : ℚ)) * X ^ 12 + C ((7665882791582 / 825337491 : ℚ)) * X ^ 13 + C ((2955830391046 / 275112497 : ℚ)) * X ^ 14 + C ((8012085784876 / 825337491 : ℚ)) * X ^ 15 + C ((5985030613390 / 825337491 : ℚ)) * X ^ 16 + C ((4324056363710 / 825337491 : ℚ)) * X ^ 17 + C ((514127391244 / 275112497 : ℚ)) * X ^ 18
theorem UP17_pre_eq :
    UA_0_1_re * UP17_Fre - UA_0_1_im * UP17_Fim = UP17_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP17_Fre, UP17_Fim, UP17_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP17_pim_eq :
    UA_0_1_re * UP17_Fim + UA_0_1_im * UP17_Fre = UP17_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_0_1_re, UA_0_1_im, UP17_Fre, UP17_Fim, UP17_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP17_mul : UA_0_1 * UP17_F = ofLadj UP17_pre UP17_pim := by
  rw [UA_0_1, UP17_F, ofLadj_mul, UP17_pre_eq, UP17_pim_eq]

def UP18_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP18_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP18_F : Ki := ofLadj UP18_Fre UP18_Fim
def UP18_pre : Polynomial ℚ := C ((-1866674549007 / 275112497 : ℚ)) + C ((1799764460449 / 275112497 : ℚ)) * X ^ 2 + C ((4935725411794 / 275112497 : ℚ)) * X ^ 3 + C ((15037329436530 / 275112497 : ℚ)) * X ^ 4 + C ((25244533402675 / 275112497 : ℚ)) * X ^ 5 + C ((35665999021229 / 275112497 : ℚ)) * X ^ 6 + C ((44195039706034 / 275112497 : ℚ)) * X ^ 7 + C ((47432534687402 / 275112497 : ℚ)) * X ^ 8 + C ((48816230669116 / 275112497 : ℚ)) * X ^ 9 + C ((49851978812237 / 275112497 : ℚ)) * X ^ 10 + C ((52123265793651 / 275112497 : ℚ)) * X ^ 11 + C ((49851978812237 / 275112497 : ℚ)) * X ^ 12 + C ((47016466208667 / 275112497 : ℚ)) * X ^ 13 + C ((42496809275608 / 275112497 : ℚ)) * X ^ 14 + C ((31141225736772 / 275112497 : ℚ)) * X ^ 15 + C ((20179918915135 / 275112497 : ℚ)) * X ^ 16 + C ((887132117871 / 25010227 : ℚ)) * X ^ 17 + C ((1983515467268 / 275112497 : ℚ)) * X ^ 18
def UP18_pim : Polynomial ℚ := C ((-6549483403329 / 275112497 : ℚ)) + C ((-13098966806658 / 275112497 : ℚ)) * X + C ((-21347268412531 / 275112497 : ℚ)) * X ^ 2 + C ((-32417758752355 / 275112497 : ℚ)) * X ^ 3 + C ((-39365373990509 / 275112497 : ℚ)) * X ^ 4 + C ((-42601855706612 / 275112497 : ℚ)) * X ^ 5 + C ((-43498733585914 / 275112497 : ℚ)) * X ^ 6 + C ((-37163774049672 / 275112497 : ℚ)) * X ^ 7 + C ((-33006546372857 / 275112497 : ℚ)) * X ^ 8 + C ((-32799640249571 / 275112497 : ℚ)) * X ^ 9 + C ((-31897230804871 / 275112497 : ℚ)) * X ^ 10 + C ((-2183161134443 / 25010227 : ℚ)) * X ^ 11 + C ((-16132314152875 / 275112497 : ℚ)) * X ^ 12 + C ((-6981603102302 / 275112497 : ℚ)) * X ^ 13 + C ((4295793360808 / 275112497 : ℚ)) * X ^ 14 + C ((10655375053263 / 275112497 : ℚ)) * X ^ 15 + C ((12738043368411 / 275112497 : ℚ)) * X ^ 16 + C ((12234034159711 / 275112497 : ℚ)) * X ^ 17 + C ((4745261222514 / 275112497 : ℚ)) * X ^ 18
theorem UP18_pre_eq :
    UA_2_0_re * UP18_Fre - UA_2_0_im * UP18_Fim = UP18_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP18_Fre, UP18_Fim, UP18_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP18_pim_eq :
    UA_2_0_re * UP18_Fim + UA_2_0_im * UP18_Fre = UP18_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP18_Fre, UP18_Fim, UP18_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP18_mul : UA_2_0 * UP18_F = ofLadj UP18_pre UP18_pim := by
  rw [UA_2_0, UP18_F, ofLadj_mul, UP18_pre_eq, UP18_pim_eq]

def UP19_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def UP19_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def UP19_F : Ki := ofLadj UP19_Fre UP19_Fim
def UP19_pre : Polynomial ℚ := C ((21496642406 / 825337491 : ℚ)) + C ((34930578151088 / 825337491 : ℚ)) * X + C ((70329897212794 / 825337491 : ℚ)) * X ^ 2 + C ((114344972625344 / 825337491 : ℚ)) * X ^ 3 + C ((192876825138980 / 825337491 : ℚ)) * X ^ 4 + C ((247330318557556 / 825337491 : ℚ)) * X ^ 5 + C ((297755923208210 / 825337491 : ℚ)) * X ^ 6 + C ((320133082035922 / 825337491 : ℚ)) * X ^ 7 + C ((99386236090964 / 275112497 : ℚ)) * X ^ 8 + C ((282138818130704 / 825337491 : ℚ)) * X ^ 9 + C ((270280353948754 / 825337491 : ℚ)) * X ^ 10 + C ((265504966448584 / 825337491 : ℚ)) * X ^ 11 + C ((235349775797666 / 825337491 : ℚ)) * X ^ 12 + C ((211808920917910 / 825337491 : ℚ)) * X ^ 13 + C ((183813735647548 / 825337491 : ℚ)) * X ^ 14 + C ((119694190738778 / 825337491 : ℚ)) * X ^ 15 + C ((6723470241530 / 75030681 : ℚ)) * X ^ 16 + C ((7844189335392 / 275112497 : ℚ)) * X ^ 17 + C ((-2520688719388 / 275112497 : ℚ)) * X ^ 18
def UP19_pim : Polynomial ℚ := C ((-33053155280878 / 825337491 : ℚ)) + C ((-66106310561756 / 825337491 : ℚ)) * X + C ((-85788364984474 / 825337491 : ℚ)) * X ^ 2 + C ((-117135795061600 / 825337491 : ℚ)) * X ^ 3 + C ((-118172254537856 / 825337491 : ℚ)) * X ^ 4 + C ((-86523903419588 / 825337491 : ℚ)) * X ^ 5 + C ((-51491333213410 / 825337491 : ℚ)) * X ^ 6 + C ((14983507960118 / 825337491 : ℚ)) * X ^ 7 + C ((51756432958204 / 825337491 : ℚ)) * X ^ 8 + C ((49316945762192 / 825337491 : ℚ)) * X ^ 9 + C ((3540696936298 / 75030681 : ℚ)) * X ^ 10 + C ((18873183595764 / 275112497 : ℚ)) * X ^ 11 + C ((74291435275306 / 825337491 : ℚ)) * X ^ 12 + C ((27868070078370 / 275112497 : ℚ)) * X ^ 13 + C ((112512153116224 / 825337491 : ℚ)) * X ^ 14 + C ((120403628040334 / 825337491 : ℚ)) * X ^ 15 + C ((101968015763678 / 825337491 : ℚ)) * X ^ 16 + C ((83180011882148 / 825337491 : ℚ)) * X ^ 17 + C ((906603319704 / 25010227 : ℚ)) * X ^ 18
theorem UP19_pre_eq :
    UA_2_0_re * UP19_Fre - UA_2_0_im * UP19_Fim = UP19_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP19_Fre, UP19_Fim, UP19_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP19_pim_eq :
    UA_2_0_re * UP19_Fim + UA_2_0_im * UP19_Fre = UP19_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP19_Fre, UP19_Fim, UP19_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP19_mul : UA_2_0 * UP19_F = ofLadj UP19_pre UP19_pim := by
  rw [UA_2_0, UP19_F, ofLadj_mul, UP19_pre_eq, UP19_pim_eq]

def UP20_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def UP20_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def UP20_F : Ki := ofLadj UP20_Fre UP20_Fim
def UP20_pre : Polynomial ℚ := C ((-19997181759032 / 825337491 : ℚ)) + C ((-139722312604352 / 825337491 : ℚ)) * X + C ((-88067783217584 / 275112497 : ℚ)) * X ^ 2 + C ((-12585693608746 / 25010227 : ℚ)) * X ^ 3 + C ((-17893574180880 / 25010227 : ℚ)) * X ^ 4 + C ((-678118499468126 / 825337491 : ℚ)) * X ^ 5 + C ((-741082636599238 / 825337491 : ℚ)) * X ^ 6 + C ((-771704899041226 / 825337491 : ℚ)) * X ^ 7 + C ((-714707264979904 / 825337491 : ℚ)) * X ^ 8 + C ((-703829878819184 / 825337491 : ℚ)) * X ^ 9 + C ((-231872878006978 / 275112497 : ℚ)) * X ^ 10 + C ((-672478833064012 / 825337491 : ℚ)) * X ^ 11 + C ((-555896321416582 / 825337491 : ℚ)) * X ^ 12 + C ((-439626529166432 / 825337491 : ℚ)) * X ^ 13 + C ((-299379375891286 / 825337491 : ℚ)) * X ^ 14 + C ((-44712111519318 / 275112497 : ℚ)) * X ^ 15 + C ((-52440306563456 / 825337491 : ℚ)) * X ^ 16 + C ((3507943522552 / 275112497 : ℚ)) * X ^ 17 + C ((47080616514232 / 825337491 : ℚ)) * X ^ 18
def UP20_pim : Polynomial ℚ := C ((20783821607112 / 275112497 : ℚ)) + C ((41567643214224 / 275112497 : ℚ)) * X + C ((39729926061016 / 275112497 : ℚ)) * X ^ 2 + C ((117346807095878 / 825337491 : ℚ)) * X ^ 3 + C ((2881890517516 / 75030681 : ℚ)) * X ^ 4 + C ((-34450137151066 / 275112497 : ℚ)) * X ^ 5 + C ((-68838397674982 / 275112497 : ℚ)) * X ^ 6 + C ((-112362129616994 / 275112497 : ℚ)) * X ^ 7 + C ((-136806191996668 / 275112497 : ℚ)) * X ^ 8 + C ((-136273709713000 / 275112497 : ℚ)) * X ^ 9 + C ((-133894074956694 / 275112497 : ℚ)) * X ^ 10 + C ((-453526961131240 / 825337491 : ℚ)) * X ^ 11 + C ((-505371697392398 / 825337491 : ℚ)) * X ^ 12 + C ((-492719641663856 / 825337491 : ℚ)) * X ^ 13 + C ((-489279223725682 / 825337491 : ℚ)) * X ^ 14 + C ((-408231290348534 / 825337491 : ℚ)) * X ^ 15 + C ((-282324077325172 / 825337491 : ℚ)) * X ^ 16 + C ((-190161310816492 / 825337491 : ℚ)) * X ^ 17 + C ((-68734109112968 / 825337491 : ℚ)) * X ^ 18
theorem UP20_pre_eq :
    UA_2_0_re * UP20_Fre - UA_2_0_im * UP20_Fim = UP20_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP20_Fre, UP20_Fim, UP20_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP20_pim_eq :
    UA_2_0_re * UP20_Fim + UA_2_0_im * UP20_Fre = UP20_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP20_Fre, UP20_Fim, UP20_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP20_mul : UA_2_0 * UP20_F = ofLadj UP20_pre UP20_pim := by
  rw [UA_2_0, UP20_F, ofLadj_mul, UP20_pre_eq, UP20_pim_eq]

def UP21_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def UP21_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def UP21_F : Ki := ofLadj UP21_Fre UP21_Fim
def UP21_pre : Polynomial ℚ := C ((337983227842 / 825337491 : ℚ)) + C ((43663222688860 / 825337491 : ℚ)) * X + C ((83302419041672 / 825337491 : ℚ)) * X ^ 2 + C ((47654867298242 / 275112497 : ℚ)) * X ^ 3 + C ((232970539808492 / 825337491 : ℚ)) * X ^ 4 + C ((100361738717126 / 275112497 : ℚ)) * X ^ 5 + C ((366385977192230 / 825337491 : ℚ)) * X ^ 6 + C ((419886605149412 / 825337491 : ℚ)) * X ^ 7 + C ((426807132926110 / 825337491 : ℚ)) * X ^ 8 + C ((441889621974200 / 825337491 : ℚ)) * X ^ 9 + C ((150997474654236 / 275112497 : ℚ)) * X ^ 10 + C ((457163140410782 / 825337491 : ℚ)) * X ^ 11 + C ((409329201273848 / 825337491 : ℚ)) * X ^ 12 + C ((119529067644176 / 275112497 : ℚ)) * X ^ 13 + C ((283842531031384 / 825337491 : ℚ)) * X ^ 14 + C ((60106075775396 / 275112497 : ℚ)) * X ^ 15 + C ((104000826534848 / 825337491 : ℚ)) * X ^ 16 + C ((12900021831332 / 275112497 : ℚ)) * X ^ 17 + C ((-2199279338244 / 275112497 : ℚ)) * X ^ 18
def UP21_pim : Polynomial ℚ := C ((-40224863533876 / 825337491 : ℚ)) + C ((-80449727067752 / 825337491 : ℚ)) * X + C ((-109137272384812 / 825337491 : ℚ)) * X ^ 2 + C ((-152526649287838 / 825337491 : ℚ)) * X ^ 3 + C ((-53420885036452 / 275112497 : ℚ)) * X ^ 4 + C ((-141928519189876 / 825337491 : ℚ)) * X ^ 5 + C ((-41488243070004 / 275112497 : ℚ)) * X ^ 6 + C ((-6713614497188 / 75030681 : ℚ)) * X ^ 7 + C ((-37432320937820 / 825337491 : ℚ)) * X ^ 8 + C ((-35111861361650 / 825337491 : ℚ)) * X ^ 9 + C ((-25388050578514 / 825337491 : ℚ)) * X ^ 10 + C ((29294376929698 / 825337491 : ℚ)) * X ^ 11 + C ((27992268145970 / 275112497 : ℚ)) * X ^ 12 + C ((40796053512702 / 275112497 : ℚ)) * X ^ 13 + C ((5093878697494 / 25010227 : ℚ)) * X ^ 14 + C ((56452697503996 / 275112497 : ℚ)) * X ^ 15 + C ((138649647556132 / 825337491 : ℚ)) * X ^ 16 + C ((3208564473800 / 25010227 : ℚ)) * X ^ 17 + C ((42893348858080 / 825337491 : ℚ)) * X ^ 18
theorem UP21_pre_eq :
    UA_2_0_re * UP21_Fre - UA_2_0_im * UP21_Fim = UP21_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP21_Fre, UP21_Fim, UP21_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP21_pim_eq :
    UA_2_0_re * UP21_Fim + UA_2_0_im * UP21_Fre = UP21_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP21_Fre, UP21_Fim, UP21_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP21_mul : UA_2_0 * UP21_F = ofLadj UP21_pre UP21_pim := by
  rw [UA_2_0, UP21_F, ofLadj_mul, UP21_pre_eq, UP21_pim_eq]

def UP22_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP22_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP22_F : Ki := ofLadj UP22_Fre UP22_Fim
def UP22_pre : Polynomial ℚ := C ((13796429904748 / 825337491 : ℚ)) + C ((174652890755440 / 825337491 : ℚ)) * X + C ((356957126619404 / 825337491 : ℚ)) * X ^ 2 + C ((585724335663748 / 825337491 : ℚ)) * X ^ 3 + C ((871103877955120 / 825337491 : ℚ)) * X ^ 4 + C ((1036763838090956 / 825337491 : ℚ)) * X ^ 5 + C ((1167389724738856 / 825337491 : ℚ)) * X ^ 6 + C ((1241037371574116 / 825337491 : ℚ)) * X ^ 7 + C ((1182307968542792 / 825337491 : ℚ)) * X ^ 8 + C ((1160024383229488 / 825337491 : ℚ)) * X ^ 9 + C ((380975636643688 / 275112497 : ℚ)) * X ^ 10 + C ((1122833236845596 / 825337491 : ℚ)) * X ^ 11 + C ((968274019175624 / 825337491 : ℚ)) * X ^ 12 + C ((803067256610084 / 825337491 : ℚ)) * X ^ 13 + C ((596583632879044 / 825337491 : ℚ)) * X ^ 14 + C ((331751167117268 / 825337491 : ℚ)) * X ^ 15 + C ((59423465896308 / 275112497 : ℚ)) * X ^ 16 + C ((47644511041024 / 825337491 : ℚ)) * X ^ 17 + C ((-38182326501728 / 825337491 : ℚ)) * X ^ 18
def UP22_pim : Polynomial ℚ := C ((-39078743815548 / 275112497 : ℚ)) + C ((-78157487631096 / 275112497 : ℚ)) * X + C ((-279243246017236 / 825337491 : ℚ)) * X ^ 2 + C ((-326841270717380 / 825337491 : ℚ)) * X ^ 3 + C ((-246837500202376 / 825337491 : ℚ)) * X ^ 4 + C ((-84113588538632 / 825337491 : ℚ)) * X ^ 5 + C ((15180988087204 / 275112497 : ℚ)) * X ^ 6 + C ((235170956200348 / 825337491 : ℚ)) * X ^ 7 + C ((115061462849688 / 275112497 : ℚ)) * X ^ 8 + C ((31092047932340 / 75030681 : ℚ)) * X ^ 9 + C ((327216893808928 / 825337491 : ℚ)) * X ^ 10 + C ((422820066540812 / 825337491 : ℚ)) * X ^ 11 + C ((172807746424232 / 275112497 : ℚ)) * X ^ 12 + C ((548398388949832 / 825337491 : ℚ)) * X ^ 13 + C ((17964380374444 / 25010227 : ℚ)) * X ^ 14 + C ((522143620879492 / 825337491 : ℚ)) * X ^ 15 + C ((126149236270580 / 275112497 : ℚ)) * X ^ 16 + C ((90430195217872 / 275112497 : ℚ)) * X ^ 17 + C ((33563531103624 / 275112497 : ℚ)) * X ^ 18
theorem UP22_pre_eq :
    UA_2_0_re * UP22_Fre - UA_2_0_im * UP22_Fim = UP22_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP22_Fre, UP22_Fim, UP22_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP22_pim_eq :
    UA_2_0_re * UP22_Fim + UA_2_0_im * UP22_Fre = UP22_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP22_Fre, UP22_Fim, UP22_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP22_mul : UA_2_0 * UP22_F = ofLadj UP22_pre UP22_pim := by
  rw [UA_2_0, UP22_F, ofLadj_mul, UP22_pre_eq, UP22_pim_eq]

def UP23_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def UP23_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def UP23_F : Ki := ofLadj UP23_Fre UP23_Fim
def UP23_pre : Polynomial ℚ := C ((8164161294118 / 825337491 : ℚ)) + C ((122257023528808 / 825337491 : ℚ)) * X + C ((245323543659676 / 825337491 : ℚ)) * X ^ 2 + C ((132560025752576 / 275112497 : ℚ)) * X ^ 3 + C ((201170849213876 / 275112497 : ℚ)) * X ^ 4 + C ((730734695141494 / 825337491 : ℚ)) * X ^ 5 + C ((281548030531464 / 275112497 : ℚ)) * X ^ 6 + C ((27940088040056 / 25010227 : ℚ)) * X ^ 7 + C ((906582267566374 / 825337491 : ℚ)) * X ^ 8 + C ((306225549189976 / 275112497 : ℚ)) * X ^ 9 + C ((309343848953430 / 275112497 : ℚ)) * X ^ 10 + C ((923249548817800 / 825337491 : ℚ)) * X ^ 11 + C ((805774523331482 / 825337491 : ℚ)) * X ^ 12 + C ((673353103910252 / 825337491 : ℚ)) * X ^ 13 + C ((508902190308646 / 825337491 : ℚ)) * X ^ 14 + C ((26532466206472 / 75030681 : ℚ)) * X ^ 15 + C ((52673453384208 / 275112497 : ℚ)) * X ^ 16 + C ((364553419006 / 6820971 : ℚ)) * X ^ 17 + C ((-26653229409028 / 825337491 : ℚ)) * X ^ 18
def UP23_pim : Polynomial ℚ := C ((-29101649578438 / 275112497 : ℚ)) + C ((-58203299156876 / 275112497 : ℚ)) * X + C ((-71224846888072 / 275112497 : ℚ)) * X ^ 2 + C ((-265392161900638 / 825337491 : ℚ)) * X ^ 3 + C ((-231406070757550 / 825337491 : ℚ)) * X ^ 4 + C ((-138100172052514 / 825337491 : ℚ)) * X ^ 5 + C ((-22091178615100 / 275112497 : ℚ)) * X ^ 6 + C ((62120700741472 / 825337491 : ℚ)) * X ^ 7 + C ((137351261520752 / 825337491 : ℚ)) * X ^ 8 + C ((46349658129484 / 275112497 : ℚ)) * X ^ 9 + C ((147123059998562 / 825337491 : ℚ)) * X ^ 10 + C ((246197972713268 / 825337491 : ℚ)) * X ^ 11 + C ((345272885427974 / 825337491 : ℚ)) * X ^ 12 + C ((392411614231672 / 825337491 : ℚ)) * X ^ 13 + C ((148608982778598 / 275112497 : ℚ)) * X ^ 14 + C ((406808211766318 / 825337491 : ℚ)) * X ^ 15 + C ((101031131369636 / 275112497 : ℚ)) * X ^ 16 + C ((219066361744814 / 825337491 : ℚ)) * X ^ 17 + C ((26754402068556 / 275112497 : ℚ)) * X ^ 18
theorem UP23_pre_eq :
    UA_2_0_re * UP23_Fre - UA_2_0_im * UP23_Fim = UP23_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP23_Fre, UP23_Fim, UP23_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP23_pim_eq :
    UA_2_0_re * UP23_Fim + UA_2_0_im * UP23_Fre = UP23_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_2_0_re, UA_2_0_im, UP23_Fre, UP23_Fim, UP23_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP23_mul : UA_2_0 * UP23_F = ofLadj UP23_pre UP23_pim := by
  rw [UA_2_0, UP23_F, ofLadj_mul, UP23_pre_eq, UP23_pim_eq]

def UP24_Fre : Polynomial ℚ := C ((9 / 2 : ℚ)) + C (3) * X ^ 2 + C ((15 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 4 + C ((9 / 4 : ℚ)) * X ^ 5 + C ((9 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((15 / 4 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP24_Fim : Polynomial ℚ := C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 7 + C ((3 / 4 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP24_F : Ki := ofLadj UP24_Fre UP24_Fim
def UP24_pre : Polynomial ℚ := C ((129561769074 / 275112497 : ℚ)) + C ((-8933796034 / 25010227 : ℚ)) * X ^ 2 + C ((-306516430962 / 275112497 : ℚ)) * X ^ 3 + C ((-965169301196 / 275112497 : ℚ)) * X ^ 4 + C ((-1627247772196 / 275112497 : ℚ)) * X ^ 5 + C ((-2317416662018 / 275112497 : ℚ)) * X ^ 6 + C ((-2868081377036 / 275112497 : ℚ)) * X ^ 7 + C ((-3074020997944 / 275112497 : ℚ)) * X ^ 8 + C ((-3162735139020 / 275112497 : ℚ)) * X ^ 9 + C ((-3232296796922 / 275112497 : ℚ)) * X ^ 10 + C ((-3386047152286 / 275112497 : ℚ)) * X ^ 11 + C ((-3232296796922 / 275112497 : ℚ)) * X ^ 12 + C ((-3064463382646 / 275112497 : ℚ)) * X ^ 13 + C ((-2767504566982 / 275112497 : ℚ)) * X ^ 14 + C ((-2025433000112 / 275112497 : ℚ)) * X ^ 15 + C ((-1314470940886 / 275112497 : ℚ)) * X ^ 16 + C ((-624302051064 / 275112497 : ℚ)) * X ^ 17 + C ((-122520924272 / 275112497 : ℚ)) * X ^ 18
def UP24_pim : Polynomial ℚ := C ((432731384070 / 275112497 : ℚ)) + C ((865462768140 / 275112497 : ℚ)) * X + C ((1400980455906 / 275112497 : ℚ)) * X ^ 2 + C ((2135852251496 / 275112497 : ℚ)) * X ^ 3 + C ((2577352126134 / 275112497 : ℚ)) * X ^ 4 + C ((2797333089222 / 275112497 : ℚ)) * X ^ 5 + C ((2855414320246 / 275112497 : ℚ)) * X ^ 6 + C ((2444812588918 / 275112497 : ℚ)) * X ^ 7 + C ((2178354654108 / 275112497 : ℚ)) * X ^ 8 + C ((2166238779612 / 275112497 : ℚ)) * X ^ 9 + C ((2106192346876 / 275112497 : ℚ)) * X ^ 10 + C ((144243794690 / 25010227 : ℚ)) * X ^ 11 + C ((1067171136304 / 275112497 : ℚ)) * X ^ 12 + C ((471607015802 / 275112497 : ℚ)) * X ^ 13 + C ((-275380654284 / 275112497 : ℚ)) * X ^ 14 + C ((-680230205976 / 275112497 : ℚ)) * X ^ 15 + C ((-822628035004 / 275112497 : ℚ)) * X ^ 16 + C ((-791293123144 / 275112497 : ℚ)) * X ^ 17 + C ((-303108257756 / 275112497 : ℚ)) * X ^ 18
theorem UP24_pre_eq :
    UA_1_1_re * UP24_Fre - UA_1_1_im * UP24_Fim = UP24_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP24_Fre, UP24_Fim, UP24_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP24_pim_eq :
    UA_1_1_re * UP24_Fim + UA_1_1_im * UP24_Fre = UP24_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP24_Fre, UP24_Fim, UP24_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP24_mul : UA_1_1 * UP24_F = ofLadj UP24_pre UP24_pim := by
  rw [UA_1_1, UP24_F, ofLadj_mul, UP24_pre_eq, UP24_pim_eq]

def UP25_Fre : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (7) * X ^ 3 + C (-2) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (-2) * X ^ 7 + C (7) * X ^ 8 + C (3) * X ^ 9
def UP25_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (3) * X ^ 3 + C (5) * X ^ 4 + C (-2) * X ^ 5 + C (6) * X ^ 6 + C (-1) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
def UP25_F : Ki := ofLadj UP25_Fre UP25_Fim
def UP25_pre : Polynomial ℚ := C ((9215470084 / 275112497 : ℚ)) + C ((-2307900715040 / 825337491 : ℚ)) * X + C ((-4547529126284 / 825337491 : ℚ)) * X ^ 2 + C ((-7432291708268 / 825337491 : ℚ)) * X ^ 3 + C ((-12599152789472 / 825337491 : ℚ)) * X ^ 4 + C ((-16098197336876 / 825337491 : ℚ)) * X ^ 5 + C ((-6492975557468 / 275112497 : ℚ)) * X ^ 6 + C ((-20898235708000 / 825337491 : ℚ)) * X ^ 7 + C ((-19431754749680 / 825337491 : ℚ)) * X ^ 8 + C ((-6137804591308 / 275112497 : ℚ)) * X ^ 9 + C ((-17600692820668 / 825337491 : ℚ)) * X ^ 10 + C ((-5785479752928 / 275112497 : ℚ)) * X ^ 11 + C ((-15292792105628 / 825337491 : ℚ)) * X ^ 12 + C ((-13865884647640 / 825337491 : ℚ)) * X ^ 13 + C ((-363620092164 / 25010227 : ℚ)) * X ^ 14 + C ((-7795993627112 / 825337491 : ℚ)) * X ^ 15 + C ((-4854665729636 / 825337491 : ℚ)) * X ^ 16 + C ((-1473936394108 / 825337491 : ℚ)) * X ^ 17 + C ((167696430472 / 275112497 : ℚ)) * X ^ 18
def UP25_pim : Polynomial ℚ := C ((2192162151092 / 825337491 : ℚ)) + C ((4384324302184 / 825337491 : ℚ)) * X + C ((1882455854820 / 275112497 : ℚ)) * X ^ 2 + C ((7791648951452 / 825337491 : ℚ)) * X ^ 3 + C ((2597277142776 / 275112497 : ℚ)) * X ^ 4 + C ((1919755820580 / 275112497 : ℚ)) * X ^ 5 + C ((1168878059252 / 275112497 : ℚ)) * X ^ 6 + C ((-882539872616 / 825337491 : ℚ)) * X ^ 7 + C ((-1064569171464 / 275112497 : ℚ)) * X ^ 8 + C ((-3060391073708 / 825337491 : ℚ)) * X ^ 9 + C ((-788518559692 / 275112497 : ℚ)) * X ^ 10 + C ((-3557231567576 / 825337491 : ℚ)) * X ^ 11 + C ((-4748907456076 / 825337491 : ℚ)) * X ^ 12 + C ((-5317115323720 / 825337491 : ℚ)) * X ^ 13 + C ((-7328080270028 / 825337491 : ℚ)) * X ^ 14 + C ((-7743435424072 / 825337491 : ℚ)) * X ^ 15 + C ((-6613259648044 / 825337491 : ℚ)) * X ^ 16 + C ((-5382780824420 / 825337491 : ℚ)) * X ^ 17 + C ((-631998321536 / 275112497 : ℚ)) * X ^ 18
theorem UP25_pre_eq :
    UA_1_1_re * UP25_Fre - UA_1_1_im * UP25_Fim = UP25_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP25_Fre, UP25_Fim, UP25_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP25_pim_eq :
    UA_1_1_re * UP25_Fim + UA_1_1_im * UP25_Fre = UP25_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP25_Fre, UP25_Fim, UP25_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP25_mul : UA_1_1 * UP25_F = ofLadj UP25_pre UP25_pim := by
  rw [UA_1_1, UP25_F, ofLadj_mul, UP25_pre_eq, UP25_pim_eq]

def UP26_Fre : Polynomial ℚ := C (-12) + C (-2) * X ^ 2 + C (-12) * X ^ 3 + C (4) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-2) * X ^ 9
def UP26_Fim : Polynomial ℚ := C (-8) + C (-16) * X + C (2) * X ^ 2 + C (-15) * X ^ 3 + C (-10) * X ^ 4 + C (1) * X ^ 5 + C (-17) * X ^ 6 + C (-6) * X ^ 7 + C (-1) * X ^ 8 + C (-18) * X ^ 9
def UP26_F : Ki := ofLadj UP26_Fre UP26_Fim
def UP26_pre : Polynomial ℚ := C ((115582414768 / 75030681 : ℚ)) + C ((9231602860160 / 825337491 : ℚ)) * X + C ((17276626488256 / 825337491 : ℚ)) * X ^ 2 + C ((9056934306340 / 275112497 : ℚ)) * X ^ 3 + C ((12907621434720 / 275112497 : ℚ)) * X ^ 4 + C ((44267714449220 / 825337491 : ℚ)) * X ^ 5 + C ((48618141739832 / 825337491 : ℚ)) * X ^ 6 + C ((50495486065436 / 825337491 : ℚ)) * X ^ 7 + C ((46797826137244 / 825337491 : ℚ)) * X ^ 8 + C ((46094214578284 / 825337491 : ℚ)) * X ^ 9 + C ((45547233573572 / 825337491 : ℚ)) * X ^ 10 + C ((44079340984688 / 825337491 : ℚ)) * X ^ 11 + C ((12105210237804 / 275112497 : ℚ)) * X ^ 12 + C ((9605862696676 / 275112497 : ℚ)) * X ^ 13 + C ((19627023218224 / 825337491 : ℚ)) * X ^ 14 + C ((8728533589388 / 825337491 : ℚ)) * X ^ 15 + C ((1189582318844 / 275112497 : ℚ)) * X ^ 16 + C ((-260560111360 / 275112497 : ℚ)) * X ^ 17 + C ((-1014696057296 / 275112497 : ℚ)) * X ^ 18
def UP26_pim : Polynomial ℚ := C ((-4152847174288 / 825337491 : ℚ)) + C ((-8305694348576 / 825337491 : ℚ)) * X + C ((-65252783440 / 6820971 : ℚ)) * X ^ 2 + C ((-8028313174916 / 825337491 : ℚ)) * X ^ 3 + C ((-2255668498936 / 825337491 : ℚ)) * X ^ 4 + C ((6433564450580 / 825337491 : ℚ)) * X ^ 5 + C ((4372762942320 / 275112497 : ℚ)) * X ^ 6 + C ((21707134383124 / 825337491 : ℚ)) * X ^ 7 + C ((26332402084244 / 825337491 : ℚ)) * X ^ 8 + C ((26233613123084 / 825337491 : ℚ)) * X ^ 9 + C ((8587498151764 / 275112497 : ℚ)) * X ^ 10 + C ((9743426972688 / 275112497 : ℚ)) * X ^ 11 + C ((990850526692 / 25010227 : ℚ)) * X ^ 12 + C ((10605613720236 / 275112497 : ℚ)) * X ^ 13 + C ((31850778578224 / 825337491 : ℚ)) * X ^ 14 + C ((8789921455004 / 275112497 : ℚ)) * X ^ 15 + C ((6096118455052 / 275112497 : ℚ)) * X ^ 16 + C ((12314658844856 / 825337491 : ℚ)) * X ^ 17 + C ((4333637238352 / 825337491 : ℚ)) * X ^ 18
theorem UP26_pre_eq :
    UA_1_1_re * UP26_Fre - UA_1_1_im * UP26_Fim = UP26_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP26_Fre, UP26_Fim, UP26_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP26_pim_eq :
    UA_1_1_re * UP26_Fim + UA_1_1_im * UP26_Fre = UP26_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP26_Fre, UP26_Fim, UP26_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP26_mul : UA_1_1 * UP26_F = ofLadj UP26_pre UP26_pim := by
  rw [UA_1_1, UP26_F, ofLadj_mul, UP26_pre_eq, UP26_pim_eq]

def UP27_Fre : Polynomial ℚ := C ((17 / 2 : ℚ)) + C (5) * X ^ 2 + C (8) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 8 + C (5) * X ^ 9
def UP27_Fim : Polynomial ℚ := C ((5 / 2 : ℚ)) + C (5) * X + C (-3) * X ^ 2 + C (5) * X ^ 3 + C ((7 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (6) * X ^ 6 + C ((3 / 2 : ℚ)) * X ^ 7 + C (8) * X ^ 9
def UP27_F : Ki := ofLadj UP27_Fre UP27_Fim
def UP27_pre : Polynomial ℚ := C ((12964384636 / 825337491 : ℚ)) + C ((-2884875893800 / 825337491 : ℚ)) * X + C ((-5377384461640 / 825337491 : ℚ)) * X ^ 2 + C ((-9298085074120 / 825337491 : ℚ)) * X ^ 3 + C ((-15195974370340 / 825337491 : ℚ)) * X ^ 4 + C ((-19574310692500 / 825337491 : ℚ)) * X ^ 5 + C ((-7980098588544 / 275112497 : ℚ)) * X ^ 6 + C ((-9120955058588 / 275112497 : ℚ)) * X ^ 7 + C ((-2529046281152 / 75030681 : ℚ)) * X ^ 8 + C ((-28773207609532 / 825337491 : ℚ)) * X ^ 9 + C ((-29539251115204 / 825337491 : ℚ)) * X ^ 10 + C ((-9934355339560 / 275112497 : ℚ)) * X ^ 11 + C ((-8884791740468 / 275112497 : ℚ)) * X ^ 12 + C ((-7798607715964 / 275112497 : ℚ)) * X ^ 13 + C ((-6173808006184 / 275112497 : ℚ)) * X ^ 14 + C ((-11715365126056 / 825337491 : ℚ)) * X ^ 15 + C ((-6813587229632 / 825337491 : ℚ)) * X ^ 16 + C ((-815867385500 / 275112497 : ℚ)) * X ^ 17 + C ((451525679368 / 825337491 : ℚ)) * X ^ 18
def UP27_pim : Polynomial ℚ := C ((889360263840 / 275112497 : ℚ)) + C ((1778720527680 / 275112497 : ℚ)) * X + C ((217697525216 / 25010227 : ℚ)) * X ^ 2 + C ((3383024136420 / 275112497 : ℚ)) * X ^ 3 + C ((10548103629572 / 825337491 : ℚ)) * X ^ 4 + C ((9445141189184 / 825337491 : ℚ)) * X ^ 5 + C ((8303730668660 / 825337491 : ℚ)) * X ^ 6 + C ((5014361912392 / 825337491 : ℚ)) * X ^ 7 + C ((893146387736 / 275112497 : ℚ)) * X ^ 8 + C ((2555288683088 / 825337491 : ℚ)) * X ^ 9 + C ((633389947820 / 275112497 : ℚ)) * X ^ 10 + C ((-1705907360360 / 825337491 : ℚ)) * X ^ 11 + C ((-5311984564180 / 825337491 : ℚ)) * X ^ 12 + C ((-2604986717632 / 275112497 : ℚ)) * X ^ 13 + C ((-10904164710148 / 825337491 : ℚ)) * X ^ 14 + C ((-3638882385668 / 275112497 : ℚ)) * X ^ 15 + C ((-2987178656984 / 275112497 : ℚ)) * X ^ 16 + C ((-6862989024572 / 825337491 : ℚ)) * X ^ 17 + C ((-2721471522640 / 825337491 : ℚ)) * X ^ 18
theorem UP27_pre_eq :
    UA_1_1_re * UP27_Fre - UA_1_1_im * UP27_Fim = UP27_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP27_Fre, UP27_Fim, UP27_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP27_pim_eq :
    UA_1_1_re * UP27_Fim + UA_1_1_im * UP27_Fre = UP27_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP27_Fre, UP27_Fim, UP27_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP27_mul : UA_1_1 * UP27_F = ofLadj UP27_pre UP27_pim := by
  rw [UA_1_1, UP27_F, ofLadj_mul, UP27_pre_eq, UP27_pim_eq]

def UP28_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP28_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP28_F : Ki := ofLadj UP28_Fre UP28_Fim
def UP28_pre : Polynomial ℚ := C ((-811887588616 / 825337491 : ℚ)) + C ((-11539503575200 / 825337491 : ℚ)) * X + C ((-23238307467752 / 825337491 : ℚ)) * X ^ 2 + C ((-12751439111344 / 275112497 : ℚ)) * X ^ 3 + C ((-18999449407264 / 275112497 : ℚ)) * X ^ 4 + C ((-22533496214352 / 275112497 : ℚ)) * X ^ 5 + C ((-76429585829576 / 825337491 : ℚ)) * X ^ 6 + C ((-81066470962384 / 825337491 : ℚ)) * X ^ 7 + C ((-77225376275912 / 825337491 : ℚ)) * X ^ 8 + C ((-75761794135336 / 825337491 : ℚ)) * X ^ 9 + C ((-74651054161424 / 825337491 : ℚ)) * X ^ 10 + C ((-2224776622088 / 25010227 : ℚ)) * X ^ 11 + C ((-63111550586224 / 825337491 : ℚ)) * X ^ 12 + C ((-52523486667584 / 825337491 : ℚ)) * X ^ 13 + C ((-38971058941880 / 825337491 : ℚ)) * X ^ 14 + C ((-21565681877840 / 825337491 : ℚ)) * X ^ 15 + C ((-11763332667632 / 825337491 : ℚ)) * X ^ 16 + C ((-978078493704 / 275112497 : ℚ)) * X ^ 17 + C ((2502440862752 / 825337491 : ℚ)) * X ^ 18
def UP28_pim : Polynomial ℚ := C ((7787447272280 / 825337491 : ℚ)) + C ((15574894544560 / 825337491 : ℚ)) * X + C ((18433433230552 / 825337491 : ℚ)) * X ^ 2 + C ((21905579299328 / 825337491 : ℚ)) * X ^ 3 + C ((16409842550576 / 825337491 : ℚ)) * X ^ 4 + C ((6001379307400 / 825337491 : ℚ)) * X ^ 5 + C ((-801658275328 / 275112497 : ℚ)) * X ^ 6 + C ((-14835877631104 / 825337491 : ℚ)) * X ^ 7 + C ((-21823622082128 / 825337491 : ℚ)) * X ^ 8 + C ((-21609926949272 / 825337491 : ℚ)) * X ^ 9 + C ((-6882148537232 / 275112497 : ℚ)) * X ^ 10 + C ((-9005920232680 / 275112497 : ℚ)) * X ^ 11 + C ((-11129691928128 / 275112497 : ℚ)) * X ^ 12 + C ((-35284133132800 / 825337491 : ℚ)) * X ^ 13 + C ((-38542584068720 / 825337491 : ℚ)) * X ^ 14 + C ((-33663044943584 / 825337491 : ℚ)) * X ^ 15 + C ((-24490775279840 / 825337491 : ℚ)) * X ^ 16 + C ((-17566256053096 / 825337491 : ℚ)) * X ^ 17 + C ((-6371546827408 / 825337491 : ℚ)) * X ^ 18
theorem UP28_pre_eq :
    UA_1_1_re * UP28_Fre - UA_1_1_im * UP28_Fim = UP28_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP28_Fre, UP28_Fim, UP28_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP28_pim_eq :
    UA_1_1_re * UP28_Fim + UA_1_1_im * UP28_Fre = UP28_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP28_Fre, UP28_Fim, UP28_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP28_mul : UA_1_1 * UP28_F = ofLadj UP28_pre UP28_pim := by
  rw [UA_1_1, UP28_F, ofLadj_mul, UP28_pre_eq, UP28_pim_eq]

def UP29_Fre : Polynomial ℚ := C (18) + C (7) * X ^ 2 + C ((33 / 2 : ℚ)) * X ^ 3 + C ((-5 / 2 : ℚ)) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C ((-5 / 2 : ℚ)) * X ^ 7 + C ((33 / 2 : ℚ)) * X ^ 8 + C (7) * X ^ 9
def UP29_Fim : Polynomial ℚ := C (7) + C (14) * X + C (-3) * X ^ 2 + C ((23 / 2 : ℚ)) * X ^ 3 + C ((21 / 2 : ℚ)) * X ^ 4 + C (-3) * X ^ 5 + C (17) * X ^ 6 + C ((7 / 2 : ℚ)) * X ^ 7 + C ((5 / 2 : ℚ)) * X ^ 8 + C (17) * X ^ 9
def UP29_F : Ki := ofLadj UP29_Fre UP29_Fim
def UP29_pre : Polynomial ℚ := C ((-464671896772 / 825337491 : ℚ)) + C ((-8077652502640 / 825337491 : ℚ)) * X + C ((-5315807605880 / 275112497 : ℚ)) * X ^ 2 + C ((-8647221488188 / 275112497 : ℚ)) * X ^ 3 + C ((-39459770000864 / 825337491 : ℚ)) * X ^ 4 + C ((-47600580125396 / 825337491 : ℚ)) * X ^ 5 + C ((-55264402401184 / 825337491 : ℚ)) * X ^ 6 + C ((-60191645933360 / 825337491 : ℚ)) * X ^ 7 + C ((-59165853525004 / 825337491 : ℚ)) * X ^ 8 + C ((-19988654633988 / 275112497 : ℚ)) * X ^ 9 + C ((-60563693237704 / 825337491 : ℚ)) * X ^ 10 + C ((-60331247122096 / 825337491 : ℚ)) * X ^ 11 + C ((-17495346911688 / 275112497 : ℚ)) * X ^ 12 + C ((-14672847028108 / 275112497 : ℚ)) * X ^ 13 + C ((-33224189060440 / 825337491 : ℚ)) * X ^ 14 + C ((-18977566209704 / 825337491 : ℚ)) * X ^ 15 + C ((-10398507270944 / 825337491 : ℚ)) * X ^ 16 + C ((-911561665052 / 275112497 : ℚ)) * X ^ 17 + C ((159482702072 / 75030681 : ℚ)) * X ^ 18
def UP29_pim : Polynomial ℚ := C ((5797398197852 / 825337491 : ℚ)) + C ((11594796395704 / 825337491 : ℚ)) * X + C ((14093630764480 / 825337491 : ℚ)) * X ^ 2 + C ((5914588913536 / 275112497 : ℚ)) * X ^ 3 + C ((15327049405676 / 825337491 : ℚ)) * X ^ 4 + C ((3129176713724 / 275112497 : ℚ)) * X ^ 5 + C ((144142565044 / 25010227 : ℚ)) * X ^ 6 + C ((-1224203943660 / 275112497 : ℚ)) * X ^ 7 + C ((-8412791619440 / 825337491 : ℚ)) * X ^ 8 + C ((-2843424702716 / 275112497 : ℚ)) * X ^ 9 + C ((-9053122013756 / 825337491 : ℚ)) * X ^ 10 + C ((-5207891323232 / 275112497 : ℚ)) * X ^ 11 + C ((-22194225925636 / 825337491 : ℚ)) * X ^ 12 + C ((-8405302733340 / 275112497 : ℚ)) * X ^ 13 + C ((-9661175554952 / 275112497 : ℚ)) * X ^ 14 + C ((-26225220740072 / 825337491 : ℚ)) * X ^ 15 + C ((-1783453325212 / 75030681 : ℚ)) * X ^ 16 + C ((-4726266584660 / 275112497 : ℚ)) * X ^ 17 + C ((-5081768378312 / 825337491 : ℚ)) * X ^ 18
theorem UP29_pre_eq :
    UA_1_1_re * UP29_Fre - UA_1_1_im * UP29_Fim = UP29_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP29_Fre, UP29_Fim, UP29_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP29_pim_eq :
    UA_1_1_re * UP29_Fim + UA_1_1_im * UP29_Fre = UP29_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UA_1_1_re, UA_1_1_im, UP29_Fre, UP29_Fim, UP29_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP29_mul : UA_1_1 * UP29_F = ofLadj UP29_pre UP29_pim := by
  rw [UA_1_1, UP29_F, ofLadj_mul, UP29_pre_eq, UP29_pim_eq]

def UP30_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP30_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP30_F : Ki := ofLadj UP30_Fre UP30_Fim
def UP30_pre : Polynomial ℚ := C ((-18289116929 / 550224994 : ℚ)) + C ((1557132937908 / 275112497 : ℚ)) * X + C ((9349026419233 / 825337491 : ℚ)) * X ^ 2 + C ((15228761465234 / 825337491 : ℚ)) * X ^ 3 + C ((17159513857999 / 550224994 : ℚ)) * X ^ 4 + C ((32959250119276 / 825337491 : ℚ)) * X ^ 5 + C ((39737720839673 / 825337491 : ℚ)) * X ^ 6 + C ((42696330256664 / 825337491 : ℚ)) * X ^ 7 + C ((26497323708697 / 550224994 : ℚ)) * X ^ 8 + C ((37630058123591 / 825337491 : ℚ)) * X ^ 9 + C ((72039683522485 / 1650674982 : ℚ)) * X ^ 10 + C ((3222029742179 / 75030681 : ℚ)) * X ^ 11 + C ((62696885895037 / 1650674982 : ℚ)) * X ^ 12 + C ((28281031704358 / 825337491 : ℚ)) * X ^ 13 + C ((4457677108693 / 150061362 : ℚ)) * X ^ 14 + C ((15946920305180 / 825337491 : ℚ)) * X ^ 15 + C ((1796831922587 / 150061362 : ℚ)) * X ^ 16 + C ((6208209707663 / 1650674982 : ℚ)) * X ^ 17 + C ((-673426109657 / 550224994 : ℚ)) * X ^ 18
def UP30_pim : Polynomial ℚ := C ((-2952655665877 / 550224994 : ℚ)) + C ((-2952655665877 / 275112497 : ℚ)) * X + C ((-22909415700685 / 1650674982 : ℚ)) * X ^ 2 + C ((-15704613456935 / 825337491 : ℚ)) * X ^ 3 + C ((-31605317370619 / 1650674982 : ℚ)) * X ^ 4 + C ((-11600731383154 / 825337491 : ℚ)) * X ^ 5 + C ((-2315691720202 / 275112497 : ℚ)) * X ^ 6 + C ((1964549002087 / 825337491 : ℚ)) * X ^ 7 + C ((13630459357037 / 1650674982 : ℚ)) * X ^ 8 + C ((6508200282445 / 825337491 : ℚ)) * X ^ 9 + C ((1704026280813 / 275112497 : ℚ)) * X ^ 10 + C ((7491913408759 / 825337491 : ℚ)) * X ^ 11 + C ((9871747975079 / 825337491 : ℚ)) * X ^ 12 + C ((7381578258523 / 550224994 : ℚ)) * X ^ 13 + C ((10010162398869 / 550224994 : ℚ)) * X ^ 14 + C ((969933566087 / 50020454 : ℚ)) * X ^ 15 + C ((27187183318649 / 1650674982 : ℚ)) * X ^ 16 + C ((22160149408645 / 1650674982 : ℚ)) * X ^ 17 + C ((10909271798 / 2273657 : ℚ)) * X ^ 18
theorem UP30_pre_eq :
    UB_0_0_re * UP30_Fre - UB_0_0_im * UP30_Fim = UP30_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP30_Fre, UP30_Fim, UP30_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP30_pim_eq :
    UB_0_0_re * UP30_Fim + UB_0_0_im * UP30_Fre = UP30_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP30_Fre, UP30_Fim, UP30_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP30_mul : UB_0_0 * UP30_F = ofLadj UP30_pre UP30_pim := by
  rw [UB_0_0, UP30_F, ofLadj_mul, UP30_pre_eq, UP30_pim_eq]

def UP31_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def UP31_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def UP31_F : Ki := ofLadj UP31_Fre UP31_Fim
def UP31_pre : Polynomial ℚ := C ((11195463812 / 275112497 : ℚ)) + C ((7785664689540 / 275112497 : ℚ)) * X + C ((44262842406659 / 825337491 : ℚ)) * X ^ 2 + C ((2308413440552 / 25010227 : ℚ)) * X ^ 3 + C ((124300333733765 / 825337491 : ℚ)) * X ^ 4 + C ((53476181452972 / 275112497 : ℚ)) * X ^ 5 + C ((195520543910885 / 825337491 : ℚ)) * X ^ 6 + C ((223883533181419 / 825337491 : ℚ)) * X ^ 7 + C ((227626647522611 / 825337491 : ℚ)) * X ^ 8 + C ((235581618328514 / 825337491 : ℚ)) * X ^ 9 + C ((241629596185688 / 825337491 : ℚ)) * X ^ 10 + C ((81292402606504 / 275112497 : ℚ)) * X ^ 11 + C ((218272602117068 / 825337491 : ℚ)) * X ^ 12 + C ((63772925307285 / 275112497 : ℚ)) * X ^ 13 + C ((151449003984395 / 825337491 : ℚ)) * X ^ 14 + C ((96038455146628 / 825337491 : ℚ)) * X ^ 15 + C ((55566095647313 / 825337491 : ℚ)) * X ^ 16 + C ((6824698698448 / 275112497 : ℚ)) * X ^ 17 + C ((-3544744301026 / 825337491 : ℚ)) * X ^ 18
def UP31_pim : Polynomial ℚ := C ((-7186997547454 / 275112497 : ℚ)) + C ((-14373995094908 / 275112497 : ℚ)) * X + C ((-58285114670609 / 825337491 : ℚ)) * X ^ 2 + C ((-27270548051214 / 275112497 : ℚ)) * X ^ 3 + C ((-85656459931577 / 825337491 : ℚ)) * X ^ 4 + C ((-25374502398512 / 275112497 : ℚ)) * X ^ 5 + C ((-66761410899119 / 825337491 : ℚ)) * X ^ 6 + C ((-39759525998003 / 825337491 : ℚ)) * X ^ 7 + C ((-20391618425483 / 825337491 : ℚ)) * X ^ 8 + C ((-19238963070592 / 825337491 : ℚ)) * X ^ 9 + C ((-4664406354800 / 275112497 : ℚ)) * X ^ 10 + C ((15270422678606 / 825337491 : ℚ)) * X ^ 11 + C ((44534064421612 / 825337491 : ℚ)) * X ^ 12 + C ((64942937813689 / 825337491 : ℚ)) * X ^ 13 + C ((29874040883871 / 275112497 : ℚ)) * X ^ 14 + C ((90119737403368 / 825337491 : ℚ)) * X ^ 15 + C ((73853992116247 / 825337491 : ℚ)) * X ^ 16 + C ((56449786050896 / 825337491 : ℚ)) * X ^ 17 + C ((22715108598700 / 825337491 : ℚ)) * X ^ 18
theorem UP31_pre_eq :
    UB_0_0_re * UP31_Fre - UB_0_0_im * UP31_Fim = UP31_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP31_Fre, UP31_Fim, UP31_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP31_pim_eq :
    UB_0_0_re * UP31_Fim + UB_0_0_im * UP31_Fre = UP31_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP31_Fre, UP31_Fim, UP31_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP31_mul : UB_0_0 * UP31_F = ofLadj UP31_pre UP31_pim := by
  rw [UB_0_0, UP31_F, ofLadj_mul, UP31_pre_eq, UP31_pim_eq]

def UP32_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP32_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP32_F : Ki := ofLadj UP32_Fre UP32_Fim
def UP32_pre : Polynomial ℚ := C ((1160756050314 / 275112497 : ℚ)) + C ((15571329379080 / 275112497 : ℚ)) * X + C ((95088973408162 / 825337491 : ℚ)) * X ^ 2 + C ((156227637282274 / 825337491 : ℚ)) * X ^ 3 + C ((232560899991050 / 825337491 : ℚ)) * X ^ 4 + C ((92142864996810 / 275112497 : ℚ)) * X ^ 5 + C ((103881579703598 / 275112497 : ℚ)) * X ^ 6 + C ((331059366181781 / 825337491 : ℚ)) * X ^ 7 + C ((105136163582335 / 275112497 : ℚ)) * X ^ 8 + C ((309448823193593 / 825337491 : ℚ)) * X ^ 9 + C ((101631702394875 / 275112497 : ℚ)) * X ^ 10 + C ((99906649970950 / 275112497 : ℚ)) * X ^ 11 + C ((86060373015795 / 275112497 : ℚ)) * X ^ 12 + C ((214359849785431 / 825337491 : ℚ)) * X ^ 13 + C ((159180853464731 / 825337491 : ℚ)) * X ^ 14 + C ((8029707465469 / 75030681 : ℚ)) * X ^ 15 + C ((15904514803780 / 275112497 : ℚ)) * X ^ 16 + C ((4165800096992 / 275112497 : ℚ)) * X ^ 17 + C ((-10171684070572 / 825337491 : ℚ)) * X ^ 18
def UP32_pim : Polynomial ℚ := C ((-10481162750138 / 275112497 : ℚ)) + C ((-20962325500276 / 275112497 : ℚ)) * X + C ((-24880114070212 / 275112497 : ℚ)) * X ^ 2 + C ((-87844261208974 / 825337491 : ℚ)) * X ^ 3 + C ((-66130370454862 / 825337491 : ℚ)) * X ^ 4 + C ((-22982806557754 / 825337491 : ℚ)) * X ^ 5 + C ((3855418659560 / 275112497 : ℚ)) * X ^ 6 + C ((20758556865869 / 275112497 : ℚ)) * X ^ 7 + C ((91425889752155 / 825337491 : ℚ)) * X ^ 8 + C ((30189816813747 / 275112497 : ℚ)) * X ^ 9 + C ((28874769759771 / 275112497 : ℚ)) * X ^ 10 + C ((112290324597382 / 825337491 : ℚ)) * X ^ 11 + C ((137956339915451 / 825337491 : ℚ)) * X ^ 12 + C ((1204665822011 / 6820971 : ℚ)) * X ^ 13 + C ((158112044150755 / 825337491 : ℚ)) * X ^ 14 + C ((138900028621573 / 825337491 : ℚ)) * X ^ 15 + C ((100819305438292 / 825337491 : ℚ)) * X ^ 16 + C ((6571901621338 / 75030681 : ℚ)) * X ^ 17 + C ((26648343929618 / 825337491 : ℚ)) * X ^ 18
theorem UP32_pre_eq :
    UB_0_0_re * UP32_Fre - UB_0_0_im * UP32_Fim = UP32_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP32_Fre, UP32_Fim, UP32_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP32_pim_eq :
    UB_0_0_re * UP32_Fim + UB_0_0_im * UP32_Fre = UP32_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP32_Fre, UP32_Fim, UP32_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP32_mul : UB_0_0 * UP32_F = ofLadj UP32_pre UP32_pim := by
  rw [UB_0_0, UP32_F, ofLadj_mul, UP32_pre_eq, UP32_pim_eq]

def UP33_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def UP33_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def UP33_F : Ki := ofLadj UP33_Fre UP33_Fim
def UP33_pre : Polynomial ℚ := C ((-484830629817 / 275112497 : ℚ)) + C ((-4671398813724 / 275112497 : ℚ)) * X + C ((-8137782755464 / 275112497 : ℚ)) * X ^ 2 + C ((-13137891787520 / 275112497 : ℚ)) * X ^ 3 + C ((-19845751840755 / 275112497 : ℚ)) * X ^ 4 + C ((-22571424273809 / 275112497 : ℚ)) * X ^ 5 + C ((-25880941053651 / 275112497 : ℚ)) * X ^ 6 + C ((-29708075167334 / 275112497 : ℚ)) * X ^ 7 + C ((-251401411339 / 2273657 : ℚ)) * X ^ 8 + C ((-32793429181980 / 275112497 : ℚ)) * X ^ 9 + C ((-34607207607464 / 275112497 : ℚ)) * X ^ 10 + C ((-34798766482010 / 275112497 : ℚ)) * X ^ 11 + C ((-29935808793740 / 275112497 : ℚ)) * X ^ 12 + C ((-24655646426516 / 275112497 : ℚ)) * X ^ 13 + C ((-17281678984499 / 275112497 : ℚ)) * X ^ 14 + C ((-8391518018036 / 275112497 : ℚ)) * X ^ 15 + C ((-4367959856064 / 275112497 : ℚ)) * X ^ 16 + C ((-1058443076222 / 275112497 : ℚ)) * X ^ 17 + C ((1470805308543 / 275112497 : ℚ)) * X ^ 18
def UP33_pim : Polynomial ℚ := C ((2677208943669 / 275112497 : ℚ)) + C ((5354417887338 / 275112497 : ℚ)) * X + C ((6171165090005 / 275112497 : ℚ)) * X ^ 2 + C ((7997731161584 / 275112497 : ℚ)) * X ^ 3 + C ((6019077321588 / 275112497 : ℚ)) * X ^ 4 + C ((2707966568067 / 275112497 : ℚ)) * X ^ 5 + C ((1820258418191 / 275112497 : ℚ)) * X ^ 6 + C ((-1538606842736 / 275112497 : ℚ)) * X ^ 7 + C ((-373096961132 / 25010227 : ℚ)) * X ^ 8 + C ((-4445304719274 / 275112497 : ℚ)) * X ^ 9 + C ((-6015716694491 / 275112497 : ℚ)) * X ^ 10 + C ((-999587501732 / 25010227 : ℚ)) * X ^ 11 + C ((-15975208343613 / 275112497 : ℚ)) * X ^ 12 + C ((-18362367521497 / 275112497 : ℚ)) * X ^ 13 + C ((-20530171739898 / 275112497 : ℚ)) * X ^ 14 + C ((-17555601566387 / 275112497 : ℚ)) * X ^ 15 + C ((-12226213606716 / 275112497 : ℚ)) * X ^ 16 + C ((-8938518530308 / 275112497 : ℚ)) * X ^ 17 + C ((-3561376063231 / 275112497 : ℚ)) * X ^ 18
theorem UP33_pre_eq :
    UB_0_0_re * UP33_Fre - UB_0_0_im * UP33_Fim = UP33_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP33_Fre, UP33_Fim, UP33_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP33_pim_eq :
    UB_0_0_re * UP33_Fim + UB_0_0_im * UP33_Fre = UP33_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP33_Fre, UP33_Fim, UP33_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP33_mul : UB_0_0 * UP33_F = ofLadj UP33_pre UP33_pim := by
  rw [UB_0_0, UP33_F, ofLadj_mul, UP33_pre_eq, UP33_pim_eq]

def UP34_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def UP34_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def UP34_F : Ki := ofLadj UP34_Fre UP34_Fim
def UP34_pre : Polynomial ℚ := C ((-3159047731064 / 275112497 : ℚ)) + C ((-43599722261424 / 275112497 : ℚ)) * X + C ((-259648557086110 / 825337491 : ℚ)) * X ^ 2 + C ((-425374213350134 / 825337491 : ℚ)) * X ^ 3 + C ((-634292605592884 / 825337491 : ℚ)) * X ^ 4 + C ((-251879961818794 / 275112497 : ℚ)) * X ^ 5 + C ((-854581894227592 / 825337491 : ℚ)) * X ^ 6 + C ((-304740257717064 / 275112497 : ℚ)) * X ^ 7 + C ((-871211939941852 / 825337491 : ℚ)) * X ^ 8 + C ((-861381664645174 / 825337491 : ℚ)) * X ^ 9 + C ((-853848196358572 / 825337491 : ℚ)) * X ^ 10 + C ((-280530880163624 / 275112497 : ℚ)) * X ^ 11 + C ((-65731729961300 / 75030681 : ℚ)) * X ^ 12 + C ((-200577702519688 / 275112497 : ℚ)) * X ^ 13 + C ((-445837726591718 / 825337491 : ℚ)) * X ^ 14 + C ((-81991897457530 / 275112497 : ℚ)) * X ^ 15 + C ((-129997606759648 / 825337491 : ℚ)) * X ^ 16 + C ((-10351865996146 / 275112497 : ℚ)) * X ^ 17 + C ((33952475185718 / 825337491 : ℚ)) * X ^ 18
def UP34_pim : Polynomial ℚ := C ((29658682287968 / 275112497 : ℚ)) + C ((59317364575936 / 275112497 : ℚ)) * X + C ((208846620157442 / 825337491 : ℚ)) * X ^ 2 + C ((250556039784230 / 825337491 : ℚ)) * X ^ 3 + C ((64119192293034 / 275112497 : ℚ)) * X ^ 4 + C ((24700489807596 / 275112497 : ℚ)) * X ^ 5 + C ((-22126088586548 / 825337491 : ℚ)) * X ^ 6 + C ((-55354987133150 / 275112497 : ℚ)) * X ^ 7 + C ((-250373016323858 / 825337491 : ℚ)) * X ^ 8 + C ((-248971802885474 / 825337491 : ℚ)) * X ^ 9 + C ((-80815697640416 / 275112497 : ℚ)) * X ^ 10 + C ((-321887146974628 / 825337491 : ℚ)) * X ^ 11 + C ((-401327201028008 / 825337491 : ℚ)) * X ^ 12 + C ((-425697017493416 / 825337491 : ℚ)) * X ^ 13 + C ((-466005223681820 / 825337491 : ℚ)) * X ^ 14 + C ((-411921877733788 / 825337491 : ℚ)) * X ^ 15 + C ((-302052123674528 / 825337491 : ℚ)) * X ^ 16 + C ((-215745457383160 / 825337491 : ℚ)) * X ^ 17 + C ((-80192937967312 / 825337491 : ℚ)) * X ^ 18
theorem UP34_pre_eq :
    UB_0_0_re * UP34_Fre - UB_0_0_im * UP34_Fim = UP34_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP34_Fre, UP34_Fim, UP34_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP34_pim_eq :
    UB_0_0_re * UP34_Fim + UB_0_0_im * UP34_Fre = UP34_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP34_Fre, UP34_Fim, UP34_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP34_mul : UB_0_0 * UP34_F = ofLadj UP34_pre UP34_pim := by
  rw [UB_0_0, UP34_F, ofLadj_mul, UP34_pre_eq, UP34_pim_eq]

def UP35_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def UP35_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def UP35_F : Ki := ofLadj UP35_Fre UP35_Fim
def UP35_pre : Polynomial ℚ := C ((-66062814599 / 275112497 : ℚ)) + C ((1557132937908 / 275112497 : ℚ)) * X + C ((9980447331694 / 825337491 : ℚ)) * X ^ 2 + C ((5681931343411 / 275112497 : ℚ)) * X ^ 3 + C ((9045776424891 / 275112497 : ℚ)) * X ^ 4 + C ((35118761732480 / 825337491 : ℚ)) * X ^ 5 + C ((13783454533656 / 275112497 : ℚ)) * X ^ 6 + C ((43202666498686 / 825337491 : ℚ)) * X ^ 7 + C ((39041909686636 / 825337491 : ℚ)) * X ^ 8 + C ((36119269786780 / 825337491 : ℚ)) * X ^ 9 + C ((33882784225187 / 825337491 : ℚ)) * X ^ 10 + C ((1007593435956 / 25010227 : ℚ)) * X ^ 11 + C ((29211385411463 / 825337491 : ℚ)) * X ^ 12 + C ((792085528942 / 25010227 : ℚ)) * X ^ 13 + C ((21996115656403 / 825337491 : ℚ)) * X ^ 14 + C ((14594531915470 / 825337491 : ℚ)) * X ^ 15 + C ((2737125744275 / 275112497 : ℚ)) * X ^ 16 + C ((1979775364337 / 825337491 : ℚ)) * X ^ 17 + C ((-490268436181 / 275112497 : ℚ)) * X ^ 18
def UP35_pim : Polynomial ℚ := C ((-1670969450177 / 275112497 : ℚ)) + C ((-3341938900354 / 275112497 : ℚ)) * X + C ((-12437322301501 / 825337491 : ℚ)) * X ^ 2 + C ((-5258754868417 / 275112497 : ℚ)) * X ^ 3 + C ((-5155258054160 / 275112497 : ℚ)) * X ^ 4 + C ((-10902050652805 / 825337491 : ℚ)) * X ^ 5 + C ((-4612040533814 / 825337491 : ℚ)) * X ^ 6 + C ((1350387093217 / 275112497 : ℚ)) * X ^ 7 + C ((803415716687 / 75030681 : ℚ)) * X ^ 8 + C ((8418800382088 / 825337491 : ℚ)) * X ^ 9 + C ((2160934612498 / 275112497 : ℚ)) * X ^ 10 + C ((8659763112190 / 825337491 : ℚ)) * X ^ 11 + C ((985156580626 / 75030681 : ℚ)) * X ^ 12 + C ((11312231442731 / 825337491 : ℚ)) * X ^ 13 + C ((14232401245012 / 825337491 : ℚ)) * X ^ 14 + C ((15146946342916 / 825337491 : ℚ)) * X ^ 15 + C ((4357300993581 / 275112497 : ℚ)) * X ^ 16 + C ((9735897729194 / 825337491 : ℚ)) * X ^ 17 + C ((3561376063231 / 825337491 : ℚ)) * X ^ 18
theorem UP35_pre_eq :
    UB_0_0_re * UP35_Fre - UB_0_0_im * UP35_Fim = UP35_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP35_Fre, UP35_Fim, UP35_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP35_pim_eq :
    UB_0_0_re * UP35_Fim + UB_0_0_im * UP35_Fre = UP35_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_0_re, UB_0_0_im, UP35_Fre, UP35_Fim, UP35_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP35_mul : UB_0_0 * UP35_F = ofLadj UP35_pre UP35_pim := by
  rw [UB_0_0, UP35_F, ofLadj_mul, UP35_pre_eq, UP35_pim_eq]

def UP36_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP36_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP36_F : Ki := ofLadj UP36_Fre UP36_Fim
def UP36_pre : Polynomial ℚ := C ((27660961789 / 275112497 : ℚ)) + C ((-15625052344984 / 825337491 : ℚ)) * X + C ((-31296076451852 / 825337491 : ℚ)) * X ^ 2 + C ((-16992971659624 / 275112497 : ℚ)) * X ^ 3 + C ((-711897458312 / 6820971 : ℚ)) * X ^ 4 + C ((-110315253929245 / 825337491 : ℚ)) * X ^ 5 + C ((-132986315876584 / 825337491 : ℚ)) * X ^ 6 + C ((-142897523024284 / 825337491 : ℚ)) * X ^ 7 + C ((-133027321629283 / 825337491 : ℚ)) * X ^ 8 + C ((-125935432022267 / 825337491 : ℚ)) * X ^ 9 + C ((-120557966494984 / 825337491 : ℚ)) * X ^ 10 + C ((-118602911320622 / 825337491 : ℚ)) * X ^ 11 + C ((-34977638050000 / 275112497 : ℚ)) * X ^ 12 + C ((-31546451856805 / 275112497 : ℚ)) * X ^ 13 + C ((-82048406650411 / 825337491 : ℚ)) * X ^ 14 + C ((-4852163909533 / 75030681 : ℚ)) * X ^ 15 + C ((-11022643971059 / 275112497 : ℚ)) * X ^ 16 + C ((-3465623321946 / 275112497 : ℚ)) * X ^ 17 + C ((1128042521223 / 275112497 : ℚ)) * X ^ 18
def UP36_pim : Polynomial ℚ := C ((14811705365179 / 825337491 : ℚ)) + C ((29623410730358 / 825337491 : ℚ)) * X + C ((38326549621124 / 825337491 : ℚ)) * X ^ 2 + C ((52521211782812 / 825337491 : ℚ)) * X ^ 3 + C ((52862090926844 / 825337491 : ℚ)) * X ^ 4 + C ((12931455470331 / 275112497 : ℚ)) * X ^ 5 + C ((23212182297374 / 825337491 : ℚ)) * X ^ 6 + C ((-6609014097842 / 825337491 : ℚ)) * X ^ 7 + C ((-22865443029347 / 825337491 : ℚ)) * X ^ 8 + C ((-21832680878825 / 825337491 : ℚ)) * X ^ 9 + C ((-1560319011830 / 75030681 : ℚ)) * X ^ 10 + C ((-25115490469690 / 825337491 : ℚ)) * X ^ 11 + C ((-33067471809250 / 825337491 : ℚ)) * X ^ 12 + C ((-12367146317107 / 275112497 : ℚ)) * X ^ 13 + C ((-16754446320829 / 275112497 : ℚ)) * X ^ 14 + C ((-17864612540279 / 275112497 : ℚ)) * X ^ 15 + C ((-45513177934619 / 825337491 : ℚ)) * X ^ 16 + C ((-12366980327590 / 275112497 : ℚ)) * X ^ 17 + C ((-4422269805729 / 275112497 : ℚ)) * X ^ 18
theorem UP36_pre_eq :
    UB_1_0_re * UP36_Fre - UB_1_0_im * UP36_Fim = UP36_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP36_Fre, UP36_Fim, UP36_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP36_pim_eq :
    UB_1_0_re * UP36_Fim + UB_1_0_im * UP36_Fre = UP36_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP36_Fre, UP36_Fim, UP36_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP36_mul : UB_1_0 * UP36_F = ofLadj UP36_pre UP36_pim := by
  rw [UB_1_0, UP36_F, ofLadj_mul, UP36_pre_eq, UP36_pim_eq]

def UP37_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def UP37_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def UP37_F : Ki := ofLadj UP37_Fre UP37_Fim
def UP37_pre : Polynomial ℚ := C ((-154977854824 / 825337491 : ℚ)) + C ((-78125261724920 / 825337491 : ℚ)) * X + C ((-148181358346672 / 825337491 : ℚ)) * X ^ 2 + C ((-23181911604080 / 75030681 : ℚ)) * X ^ 3 + C ((-416007335894116 / 825337491 : ℚ)) * X ^ 4 + C ((-536989162345216 / 825337491 : ℚ)) * X ^ 5 + C ((-218118411032664 / 275112497 : ℚ)) * X ^ 6 + C ((-749347507251004 / 825337491 : ℚ)) * X ^ 7 + C ((-761840470554916 / 825337491 : ℚ)) * X ^ 8 + C ((-788505510881920 / 825337491 : ℚ)) * X ^ 9 + C ((-269565806978492 / 275112497 : ℚ)) * X ^ 10 + C ((-816215368075064 / 825337491 : ℚ)) * X ^ 11 + C ((-730572159210556 / 825337491 : ℚ)) * X ^ 12 + C ((-213441384178416 / 275112497 : ℚ)) * X ^ 13 + C ((-168946480970012 / 275112497 : ℚ)) * X ^ 14 + C ((-107154896229836 / 275112497 : ℚ)) * X ^ 15 + C ((-185934114729368 / 825337491 : ℚ)) * X ^ 16 + C ((-22856014658864 / 275112497 : ℚ)) * X ^ 17 + C ((3958494222460 / 275112497 : ℚ)) * X ^ 18
def UP37_pim : Polynomial ℚ := C ((24035131760924 / 275112497 : ℚ)) + C ((48070263521848 / 275112497 : ℚ)) * X + C ((195016687202036 / 825337491 : ℚ)) * X ^ 2 + C ((91199302573568 / 275112497 : ℚ)) * X ^ 3 + C ((26050638421856 / 75030681 : ℚ)) * X ^ 4 + C ((84855985208512 / 275112497 : ℚ)) * X ^ 5 + C ((223238548374364 / 825337491 : ℚ)) * X ^ 6 + C ((132812364477904 / 825337491 : ℚ)) * X ^ 7 + C ((2059496205412 / 25010227 : ℚ)) * X ^ 8 + C ((64067521144928 / 825337491 : ℚ)) * X ^ 9 + C ((46527144915820 / 825337491 : ℚ)) * X ^ 10 + C ((-51358453709776 / 825337491 : ℚ)) * X ^ 11 + C ((-49748017445124 / 275112497 : ℚ)) * X ^ 12 + C ((-72530108400324 / 275112497 : ℚ)) * X ^ 13 + C ((-300067399353308 / 825337491 : ℚ)) * X ^ 14 + C ((-301776503202124 / 825337491 : ℚ)) * X ^ 15 + C ((-247302363077708 / 825337491 : ℚ)) * X ^ 16 + C ((-189010257776200 / 825337491 : ℚ)) * X ^ 17 + C ((-25366333590068 / 275112497 : ℚ)) * X ^ 18
theorem UP37_pre_eq :
    UB_1_0_re * UP37_Fre - UB_1_0_im * UP37_Fim = UP37_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP37_Fre, UP37_Fim, UP37_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP37_pim_eq :
    UB_1_0_re * UP37_Fim + UB_1_0_im * UP37_Fre = UP37_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP37_Fre, UP37_Fim, UP37_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP37_mul : UB_1_0 * UP37_F = ofLadj UP37_pre UP37_pim := by
  rw [UB_1_0, UP37_F, ofLadj_mul, UP37_pre_eq, UP37_pim_eq]

def UP38_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP38_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP38_F : Ki := ofLadj UP38_Fre UP38_Fim
def UP38_pre : Polynomial ℚ := C ((-11707801342828 / 825337491 : ℚ)) + C ((-156250523449840 / 825337491 : ℚ)) * X + C ((-106078924651560 / 275112497 : ℚ)) * X ^ 2 + C ((-174288364283468 / 275112497 : ℚ)) * X ^ 3 + C ((-778248972319936 / 825337491 : ℚ)) * X ^ 4 + C ((-925164749713208 / 825337491 : ℚ)) * X ^ 5 + C ((-347633714154536 / 275112497 : ℚ)) * X ^ 6 + C ((-1107950175239780 / 825337491 : ℚ)) * X ^ 7 + C ((-351844762573116 / 275112497 : ℚ)) * X ^ 8 + C ((-1035593972942000 / 825337491 : ℚ)) * X ^ 9 + C ((-1020351793041260 / 825337491 : ℚ)) * X ^ 10 + C ((-1002976261201340 / 825337491 : ℚ)) * X ^ 11 + C ((-864101269591420 / 825337491 : ℚ)) * X ^ 12 + C ((-717357198987320 / 825337491 : ℚ)) * X ^ 13 + C ((-177556398289648 / 275112497 : ℚ)) * X ^ 14 + C ((-295624470944656 / 825337491 : ℚ)) * X ^ 15 + C ((-53201160611772 / 275112497 : ℚ)) * X ^ 16 + C ((-41867089084916 / 825337491 : ℚ)) * X ^ 17 + C ((11358910658396 / 275112497 : ℚ)) * X ^ 18
def UP38_pim : Polynomial ℚ := C ((105148159703084 / 825337491 : ℚ)) + C ((210296319406168 / 825337491 : ℚ)) * X + C ((249717381884680 / 825337491 : ℚ)) * X ^ 2 + C ((293700107139676 / 825337491 : ℚ)) * X ^ 3 + C ((221135817390352 / 825337491 : ℚ)) * X ^ 4 + C ((76633186942348 / 825337491 : ℚ)) * X ^ 5 + C ((-3547954840844 / 75030681 : ℚ)) * X ^ 6 + C ((-69589816430848 / 275112497 : ℚ)) * X ^ 7 + C ((-102135736411344 / 275112497 : ℚ)) * X ^ 8 + C ((-101182373571984 / 275112497 : ℚ)) * X ^ 9 + C ((-290344235650316 / 825337491 : ℚ)) * X ^ 10 + C ((-125385107818924 / 275112497 : ℚ)) * X ^ 11 + C ((-461966411263228 / 825337491 : ℚ)) * X ^ 12 + C ((-162728196225368 / 275112497 : ℚ)) * X ^ 13 + C ((-176435741804340 / 275112497 : ℚ)) * X ^ 14 + C ((-155034928565652 / 275112497 : ℚ)) * X ^ 15 + C ((-337568001613076 / 825337491 : ℚ)) * X ^ 16 + C ((-80684003195788 / 275112497 : ℚ)) * X ^ 17 + C ((-29758636636076 / 275112497 : ℚ)) * X ^ 18
theorem UP38_pre_eq :
    UB_1_0_re * UP38_Fre - UB_1_0_im * UP38_Fim = UP38_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP38_Fre, UP38_Fim, UP38_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP38_pim_eq :
    UB_1_0_re * UP38_Fim + UB_1_0_im * UP38_Fre = UP38_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP38_Fre, UP38_Fim, UP38_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP38_mul : UB_1_0 * UP38_F = ofLadj UP38_pre UP38_pim := by
  rw [UB_1_0, UP38_F, ofLadj_mul, UP38_pre_eq, UP38_pim_eq]

def UP39_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def UP39_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def UP39_F : Ki := ofLadj UP39_Fre UP39_Fim
def UP39_pre : Polynomial ℚ := C ((1626693959610 / 275112497 : ℚ)) + C ((15625052344984 / 275112497 : ℚ)) * X + C ((27236070479370 / 275112497 : ℚ)) * X ^ 2 + C ((3997514223112 / 25010227 : ℚ)) * X ^ 3 + C ((66410204794416 / 275112497 : ℚ)) * X ^ 4 + C ((75550886106258 / 275112497 : ℚ)) * X ^ 5 + C ((86608735904582 / 275112497 : ℚ)) * X ^ 6 + C ((99422397075882 / 275112497 : ℚ)) * X ^ 7 + C ((101799572844162 / 275112497 : ℚ)) * X ^ 8 + C ((109747826479058 / 275112497 : ℚ)) * X ^ 9 + C ((115815981033832 / 275112497 : ℚ)) * X ^ 10 + C ((116450391227832 / 275112497 : ℚ)) * X ^ 11 + C ((100190928688848 / 275112497 : ℚ)) * X ^ 12 + C ((82511755999688 / 275112497 : ℚ)) * X ^ 13 + C ((57826916389930 / 275112497 : ℚ)) * X ^ 14 + C ((28084765299750 / 275112497 : ℚ)) * X ^ 15 + C ((14604136842076 / 275112497 : ℚ)) * X ^ 16 + C ((3546287043752 / 275112497 : ℚ)) * X ^ 17 + C ((-4927426981716 / 275112497 : ℚ)) * X ^ 18
def UP39_pim : Polynomial ℚ := C ((-8952310735810 / 275112497 : ℚ)) + C ((-17904621471620 / 275112497 : ℚ)) * X + C ((-20647615910358 / 275112497 : ℚ)) * X ^ 2 + C ((-26736846138320 / 275112497 : ℚ)) * X ^ 3 + C ((-20130243475348 / 275112497 : ℚ)) * X ^ 4 + C ((-9040069768014 / 275112497 : ℚ)) * X ^ 5 + C ((-6059374173630 / 275112497 : ℚ)) * X ^ 6 + C ((5181445755758 / 275112497 : ℚ)) * X ^ 7 + C ((13776408862114 / 275112497 : ℚ)) * X ^ 8 + C ((14919003611394 / 275112497 : ℚ)) * X ^ 9 + C ((20178285818656 / 275112497 : ℚ)) * X ^ 10 + C ((36834279728428 / 275112497 : ℚ)) * X ^ 11 + C ((53490273638200 / 275112497 : ℚ)) * X ^ 12 + C ((61492550284200 / 275112497 : ℚ)) * X ^ 13 + C ((68724375261442 / 275112497 : ℚ)) * X ^ 14 + C ((58781597257274 / 275112497 : ℚ)) * X ^ 15 + C ((3721456689848 / 25010227 : ℚ)) * X ^ 16 + C ((29927358338552 / 275112497 : ℚ)) * X ^ 17 + C ((11931138447552 / 275112497 : ℚ)) * X ^ 18
theorem UP39_pre_eq :
    UB_1_0_re * UP39_Fre - UB_1_0_im * UP39_Fim = UP39_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP39_Fre, UP39_Fim, UP39_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP39_pim_eq :
    UB_1_0_re * UP39_Fim + UB_1_0_im * UP39_Fre = UP39_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP39_Fre, UP39_Fim, UP39_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP39_mul : UB_1_0 * UP39_F = ofLadj UP39_pre UP39_pim := by
  rw [UB_1_0, UP39_F, ofLadj_mul, UP39_pre_eq, UP39_pim_eq]

def UP40_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def UP40_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def UP40_F : Ki := ofLadj UP40_Fre UP40_Fim
def UP40_pre : Polynomial ℚ := C ((10623338703088 / 275112497 : ℚ)) + C ((437501465659552 / 825337491 : ℚ)) * X + C ((868988076215332 / 825337491 : ℚ)) * X ^ 2 + C ((1423682713308668 / 825337491 : ℚ)) * X ^ 3 + C ((2122614700730152 / 825337491 : ℚ)) * X ^ 4 + C ((2529044293153732 / 825337491 : ℚ)) * X ^ 5 + C ((953262259958292 / 275112497 : ℚ)) * X ^ 6 + C ((3059623844001020 / 825337491 : ℚ)) * X ^ 7 + C ((2915535707936932 / 825337491 : ℚ)) * X ^ 8 + C ((2882692715324608 / 825337491 : ℚ)) * X ^ 9 + C ((2857422487253588 / 825337491 : ℚ)) * X ^ 10 + C ((938767288800376 / 275112497 : ℚ)) * X ^ 11 + C ((2419921021594036 / 825337491 : ℚ)) * X ^ 12 + C ((671234879703092 / 275112497 : ℚ)) * X ^ 13 + C ((1491852994628264 / 825337491 : ℚ)) * X ^ 14 + C ((74842096890416 / 75030681 : ℚ)) * X ^ 15 + C ((144931578787620 / 275112497 : ℚ)) * X ^ 16 + C ((104052249641716 / 825337491 : ℚ)) * X ^ 17 + C ((-37915359158764 / 275112497 : ℚ)) * X ^ 18
def UP40_pim : Polynomial ℚ := C ((-297539857637632 / 825337491 : ℚ)) + C ((-595079715275264 / 825337491 : ℚ)) * X + C ((-698738637326780 / 825337491 : ℚ)) * X ^ 2 + C ((-837718724441516 / 825337491 : ℚ)) * X ^ 3 + C ((-643280617655840 / 825337491 : ℚ)) * X ^ 4 + C ((-82406499234700 / 275112497 : ℚ)) * X ^ 5 + C ((74900859761924 / 825337491 : ℚ)) * X ^ 6 + C ((556734646195132 / 825337491 : ℚ)) * X ^ 7 + C ((279702743876708 / 275112497 : ℚ)) * X ^ 8 + C ((834458528454368 / 825337491 : ℚ)) * X ^ 9 + C ((812612342658196 / 825337491 : ℚ)) * X ^ 10 + C ((1078234989430936 / 825337491 : ℚ)) * X ^ 11 + C ((122168876018516 / 75030681 : ℚ)) * X ^ 12 + C ((475223457486340 / 275112497 : ℚ)) * X ^ 13 + C ((1560000756398000 / 825337491 : ℚ)) * X ^ 14 + C ((1379277991528984 / 825337491 : ℚ)) * X ^ 15 + C ((1011336413036164 / 825337491 : ℚ)) * X ^ 16 + C ((240790829497540 / 275112497 : ℚ)) * X ^ 17 + C ((89552747839444 / 275112497 : ℚ)) * X ^ 18
theorem UP40_pre_eq :
    UB_1_0_re * UP40_Fre - UB_1_0_im * UP40_Fim = UP40_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP40_Fre, UP40_Fim, UP40_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP40_pim_eq :
    UB_1_0_re * UP40_Fim + UB_1_0_im * UP40_Fre = UP40_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP40_Fre, UP40_Fim, UP40_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP40_mul : UB_1_0 * UP40_F = ofLadj UP40_pre UP40_pim := by
  rw [UB_1_0, UP40_F, ofLadj_mul, UP40_pre_eq, UP40_pim_eq]

def UP41_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def UP41_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def UP41_F : Ki := ofLadj UP41_Fre UP41_Fim
def UP41_pre : Polynomial ℚ := C ((652875167026 / 825337491 : ℚ)) + C ((-15625052344984 / 825337491 : ℚ)) * X + C ((-11136422717186 / 275112497 : ℚ)) * X ^ 2 + C ((-57058294441234 / 825337491 : ℚ)) * X ^ 3 + C ((-90820625584232 / 825337491 : ℚ)) * X ^ 4 + C ((-117537880693408 / 825337491 : ℚ)) * X ^ 5 + C ((-138379783706162 / 825337491 : ℚ)) * X ^ 6 + C ((-48199594670670 / 275112497 : ℚ)) * X ^ 7 + C ((-43555251178408 / 275112497 : ℚ)) * X ^ 8 + C ((-120885321248150 / 825337491 : ℚ)) * X ^ 9 + C ((-113394452315954 / 825337491 : ℚ)) * X ^ 10 + C ((-37091999714208 / 275112497 : ℚ)) * X ^ 11 + C ((-97769399970970 / 825337491 : ℚ)) * X ^ 12 + C ((-87476053096592 / 825337491 : ℚ)) * X ^ 13 + C ((-73607459093990 / 825337491 : ℚ)) * X ^ 14 + C ((-48850731446062 / 825337491 : ℚ)) * X ^ 15 + C ((-9158262964200 / 275112497 : ℚ)) * X ^ 16 + C ((-6632885879846 / 825337491 : ℚ)) * X ^ 17 + C ((1642475660572 / 275112497 : ℚ)) * X ^ 18
def UP41_pim : Polynomial ℚ := C ((5588278969434 / 275112497 : ℚ)) + C ((11176557938868 / 275112497 : ℚ)) * X + C ((41615352133882 / 825337491 : ℚ)) * X ^ 2 + C ((52761242838614 / 825337491 : ℚ)) * X ^ 3 + C ((51737413686604 / 825337491 : ℚ)) * X ^ 4 + C ((36448376458540 / 825337491 : ℚ)) * X ^ 5 + C ((5134599283350 / 275112497 : ℚ)) * X ^ 6 + C ((-4533616890310 / 275112497 : ℚ)) * X ^ 7 + C ((-29628225704536 / 825337491 : ℚ)) * X ^ 8 + C ((-28229704021502 / 825337491 : ℚ)) * X ^ 9 + C ((-7248141797894 / 275112497 : ℚ)) * X ^ 10 + C ((-29021753555936 / 825337491 : ℚ)) * X ^ 11 + C ((-36299081718190 / 825337491 : ℚ)) * X ^ 12 + C ((-12633160469216 / 275112497 : ℚ)) * X ^ 13 + C ((-47646850429346 / 825337491 : ℚ)) * X ^ 14 + C ((-50719257863390 / 825337491 : ℚ)) * X ^ 15 + C ((-14589102442012 / 275112497 : ℚ)) * X ^ 16 + C ((-32598700277822 / 825337491 : ℚ)) * X ^ 17 + C ((-3977046149184 / 275112497 : ℚ)) * X ^ 18
theorem UP41_pre_eq :
    UB_1_0_re * UP41_Fre - UB_1_0_im * UP41_Fim = UP41_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP41_Fre, UP41_Fim, UP41_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP41_pim_eq :
    UB_1_0_re * UP41_Fim + UB_1_0_im * UP41_Fre = UP41_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_0_re, UB_1_0_im, UP41_Fre, UP41_Fim, UP41_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP41_mul : UB_1_0 * UP41_F = ofLadj UP41_pre UP41_pim := by
  rw [UB_1_0, UP41_F, ofLadj_mul, UP41_pre_eq, UP41_pim_eq]

def UP42_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP42_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP42_F : Ki := ofLadj UP42_Fre UP42_Fim
def UP42_pre : Polynomial ℚ := C ((-10304984747 / 825337491 : ℚ)) + C ((247805098248 / 275112497 : ℚ)) * X + C ((1478884407010 / 825337491 : ℚ)) * X ^ 2 + C ((804774201657 / 275112497 : ℚ)) * X ^ 3 + C ((4090523540009 / 825337491 : ℚ)) * X ^ 4 + C ((5229349976245 / 825337491 : ℚ)) * X ^ 5 + C ((6314190502624 / 825337491 : ℚ)) * X ^ 6 + C ((2259806806167 / 275112497 : ℚ)) * X ^ 7 + C ((6308090616341 / 825337491 : ℚ)) * X ^ 8 + C ((1991994694017 / 275112497 : ℚ)) * X ^ 9 + C ((5714432615321 / 825337491 : ℚ)) * X ^ 10 + C ((1878042017074 / 275112497 : ℚ)) * X ^ 11 + C ((451910665507 / 75030681 : ℚ)) * X ^ 12 + C ((4497099675041 / 825337491 : ℚ)) * X ^ 13 + C ((3893768011370 / 825337491 : ℚ)) * X ^ 14 + C ((2528869255753 / 825337491 : ℚ)) * X ^ 15 + C ((1572006298138 / 825337491 : ℚ)) * X ^ 16 + C ((487165771759 / 825337491 : ℚ)) * X ^ 17 + C ((-53342540913 / 275112497 : ℚ)) * X ^ 18
def UP42_pim : Polynomial ℚ := C ((-706533756739 / 825337491 : ℚ)) + C ((-1413067513478 / 825337491 : ℚ)) * X + C ((-1819224922268 / 825337491 : ℚ)) * X ^ 2 + C ((-2506803416267 / 825337491 : ℚ)) * X ^ 3 + C ((-838528466943 / 275112497 : ℚ)) * X ^ 4 + C ((-1851460475327 / 825337491 : ℚ)) * X ^ 5 + C ((-1115053890440 / 825337491 : ℚ)) * X ^ 6 + C ((28069043459 / 75030681 : ℚ)) * X ^ 7 + C ((1070286634375 / 825337491 : ℚ)) * X ^ 8 + C ((1025008863157 / 825337491 : ℚ)) * X ^ 9 + C ((801152376577 / 825337491 : ℚ)) * X ^ 10 + C ((1182275462822 / 825337491 : ℚ)) * X ^ 11 + C ((521132849689 / 275112497 : ℚ)) * X ^ 12 + C ((581899823759 / 275112497 : ℚ)) * X ^ 13 + C ((796000064686 / 275112497 : ℚ)) * X ^ 14 + C ((2534226015679 / 825337491 : ℚ)) * X ^ 15 + C ((719935808294 / 275112497 : ℚ)) * X ^ 16 + C ((53278495547 / 25010227 : ℚ)) * X ^ 17 + C ((208027773089 / 275112497 : ℚ)) * X ^ 18
theorem UP42_pre_eq :
    UB_0_1_re * UP42_Fre - UB_0_1_im * UP42_Fim = UP42_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP42_Fre, UP42_Fim, UP42_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP42_pim_eq :
    UB_0_1_re * UP42_Fim + UB_0_1_im * UP42_Fre = UP42_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP42_Fre, UP42_Fim, UP42_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP42_mul : UB_0_1 * UP42_F = ofLadj UP42_pre UP42_pim := by
  rw [UB_0_1, UP42_F, ofLadj_mul, UP42_pre_eq, UP42_pim_eq]

def UP43_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def UP43_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def UP43_F : Ki := ofLadj UP43_Fre UP43_Fim
def UP43_pre : Polynomial ℚ := C ((-23502236816 / 825337491 : ℚ)) + C ((1239025491240 / 275112497 : ℚ)) * X + C ((6995912175716 / 825337491 : ℚ)) * X ^ 2 + C ((12079780687748 / 825337491 : ℚ)) * X ^ 3 + C ((19744264980472 / 825337491 : ℚ)) * X ^ 4 + C ((25442841807788 / 825337491 : ℚ)) * X ^ 5 + C ((10352515073152 / 275112497 : ℚ)) * X ^ 6 + C ((35528611645900 / 825337491 : ℚ)) * X ^ 7 + C ((36137299705472 / 825337491 : ℚ)) * X ^ 8 + C ((12461056809260 / 275112497 : ℚ)) * X ^ 9 + C ((12788608514020 / 275112497 : ℚ)) * X ^ 10 + C ((38728743537860 / 825337491 : ℚ)) * X ^ 11 + C ((1049962092980 / 25010227 : ℚ)) * X ^ 12 + C ((30387258252064 / 825337491 : ℚ)) * X ^ 13 + C ((8019173005908 / 275112497 : ℚ)) * X ^ 14 + C ((15221036415032 / 825337491 : ℚ)) * X ^ 15 + C ((8837029939504 / 825337491 : ℚ)) * X ^ 16 + C ((1074108842612 / 275112497 : ℚ)) * X ^ 17 + C ((-563310250396 / 825337491 : ℚ)) * X ^ 18
def UP43_pim : Polynomial ℚ := C ((-312703806532 / 75030681 : ℚ)) + C ((-625407613064 / 75030681 : ℚ)) * X + C ((-9255917402048 / 825337491 : ℚ)) * X ^ 2 + C ((-13061403109520 / 825337491 : ℚ)) * X ^ 3 + C ((-13622182313824 / 825337491 : ℚ)) * X ^ 4 + C ((-12151455983648 / 825337491 : ℚ)) * X ^ 5 + C ((-3550486129952 / 275112497 : ℚ)) * X ^ 6 + C ((-6361580128760 / 825337491 : ℚ)) * X ^ 7 + C ((-3291783790072 / 825337491 : ℚ)) * X ^ 8 + C ((-3124487503216 / 825337491 : ℚ)) * X ^ 9 + C ((-2280377898884 / 825337491 : ℚ)) * X ^ 10 + C ((2380154664076 / 825337491 : ℚ)) * X ^ 11 + C ((7040687227036 / 825337491 : ℚ)) * X ^ 12 + C ((10261230489712 / 825337491 : ℚ)) * X ^ 13 + C ((14234012484040 / 825337491 : ℚ)) * X ^ 14 + C ((14284373373676 / 825337491 : ℚ)) * X ^ 15 + C ((11719864463372 / 825337491 : ℚ)) * X ^ 16 + C ((8963875494580 / 825337491 : ℚ)) * X ^ 17 + C ((108491353132 / 25010227 : ℚ)) * X ^ 18
theorem UP43_pre_eq :
    UB_0_1_re * UP43_Fre - UB_0_1_im * UP43_Fim = UP43_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP43_Fre, UP43_Fim, UP43_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP43_pim_eq :
    UB_0_1_re * UP43_Fim + UB_0_1_im * UP43_Fre = UP43_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP43_Fre, UP43_Fim, UP43_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP43_mul : UB_0_1 * UP43_F = ofLadj UP43_pre UP43_pim := by
  rw [UB_0_1, UP43_F, ofLadj_mul, UP43_pre_eq, UP43_pim_eq]

def UP44_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP44_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP44_F : Ki := ofLadj UP44_Fre UP44_Fim
def UP44_pre : Polynomial ℚ := C ((171149754916 / 275112497 : ℚ)) + C ((2478050982480 / 275112497 : ℚ)) * X + C ((5024018351096 / 275112497 : ℚ)) * X ^ 2 + C ((24800928493760 / 825337491 : ℚ)) * X ^ 3 + C ((36964820315884 / 825337491 : ℚ)) * X ^ 4 + C ((43873549317568 / 825337491 : ℚ)) * X ^ 5 + C ((49527388784836 / 825337491 : ℚ)) * X ^ 6 + C ((52565774487656 / 825337491 : ℚ)) * X ^ 7 + C ((50086466406488 / 825337491 : ℚ)) * X ^ 8 + C ((49137315790100 / 825337491 : ℚ)) * X ^ 9 + C ((48415500218104 / 825337491 : ℚ)) * X ^ 10 + C ((47631339833812 / 825337491 : ℚ)) * X ^ 11 + C ((40981347270664 / 825337491 : ℚ)) * X ^ 12 + C ((34065260736812 / 825337491 : ℚ)) * X ^ 13 + C ((8428512637576 / 275112497 : ℚ)) * X ^ 14 + C ((13992162665368 / 825337491 : ℚ)) * X ^ 15 + C ((7601083693268 / 825337491 : ℚ)) * X ^ 16 + C ((1947244226000 / 825337491 : ℚ)) * X ^ 17 + C ((-536263835468 / 275112497 : ℚ)) * X ^ 18
def UP44_pim : Polynomial ℚ := C ((-5020945506844 / 825337491 : ℚ)) + C ((-10041891013688 / 825337491 : ℚ)) * X + C ((-3955371588288 / 275112497 : ℚ)) * X ^ 2 + C ((-14055662032448 / 825337491 : ℚ)) * X ^ 3 + C ((-10541877051716 / 825337491 : ℚ)) * X ^ 4 + C ((-3732455682308 / 825337491 : ℚ)) * X ^ 5 + C ((584952537232 / 275112497 : ℚ)) * X ^ 6 + C ((9833011903580 / 825337491 : ℚ)) * X ^ 7 + C ((14432627637896 / 825337491 : ℚ)) * X ^ 8 + C ((118130768420 / 6820971 : ℚ)) * X ^ 9 + C ((13667843622008 / 825337491 : ℚ)) * X ^ 10 + C ((17770076986172 / 825337491 : ℚ)) * X ^ 11 + C ((21872310350336 / 825337491 : ℚ)) * X ^ 12 + C ((7690184914900 / 275112497 : ℚ)) * X ^ 13 + C ((25121297353208 / 825337491 : ℚ)) * X ^ 14 + C ((7336057508244 / 275112497 : ℚ)) * X ^ 15 + C ((16001794708628 / 825337491 : ℚ)) * X ^ 16 + C ((1043096938240 / 75030681 : ℚ)) * X ^ 17 + C ((4198955582060 / 825337491 : ℚ)) * X ^ 18
theorem UP44_pre_eq :
    UB_0_1_re * UP44_Fre - UB_0_1_im * UP44_Fim = UP44_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP44_Fre, UP44_Fim, UP44_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP44_pim_eq :
    UB_0_1_re * UP44_Fim + UB_0_1_im * UP44_Fre = UP44_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP44_Fre, UP44_Fim, UP44_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP44_mul : UB_0_1 * UP44_F = ofLadj UP44_pre UP44_pim := by
  rw [UB_0_1, UP44_F, ofLadj_mul, UP44_pre_eq, UP44_pim_eq]

def UP45_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def UP45_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def UP45_F : Ki := ofLadj UP45_Fre UP45_Fim
def UP45_pre : Polynomial ℚ := C ((-73763076010 / 275112497 : ℚ)) + C ((-743415294744 / 275112497 : ℚ)) * X + C ((-1289279290770 / 275112497 : ℚ)) * X ^ 2 + C ((-2084835648450 / 275112497 : ℚ)) * X ^ 3 + C ((-3155960442198 / 275112497 : ℚ)) * X ^ 4 + C ((-3579309774740 / 275112497 : ℚ)) * X ^ 5 + C ((-4113350638252 / 275112497 : ℚ)) * X ^ 6 + C ((-4716392908892 / 275112497 : ℚ)) * X ^ 7 + C ((-4830489738070 / 275112497 : ℚ)) * X ^ 8 + C ((-5207651385102 / 275112497 : ℚ)) * X ^ 9 + C ((-5496268141984 / 275112497 : ℚ)) * X ^ 10 + C ((-5530299448528 / 275112497 : ℚ)) * X ^ 11 + C ((-4752852847240 / 275112497 : ℚ)) * X ^ 12 + C ((-3918372094332 / 275112497 : ℚ)) * X ^ 13 + C ((-2745654089620 / 275112497 : ℚ)) * X ^ 14 + C ((-1327862242902 / 275112497 : ℚ)) * X ^ 15 + C ((-697694093388 / 275112497 : ℚ)) * X ^ 16 + C ((-163653229876 / 275112497 : ℚ)) * X ^ 17 + C ((232570223792 / 275112497 : ℚ)) * X ^ 18
def UP45_pim : Polynomial ℚ := C ((427753021210 / 275112497 : ℚ)) + C ((855506042420 / 275112497 : ℚ)) * X + C ((979908826418 / 275112497 : ℚ)) * X ^ 2 + C ((1280544176038 / 275112497 : ℚ)) * X ^ 3 + C ((957911074298 / 275112497 : ℚ)) * X ^ 4 + C ((436879750980 / 275112497 : ℚ)) * X ^ 5 + C ((298370208900 / 275112497 : ℚ)) * X ^ 6 + C ((-239271956452 / 275112497 : ℚ)) * X ^ 7 + C ((-642258031062 / 275112497 : ℚ)) * X ^ 8 + C ((-696439629630 / 275112497 : ℚ)) * X ^ 9 + C ((-945650200076 / 275112497 : ℚ)) * X ^ 10 + C ((-1739836933880 / 275112497 : ℚ)) * X ^ 11 + C ((-2534023667684 / 275112497 : ℚ)) * X ^ 12 + C ((-2907637022128 / 275112497 : ℚ)) * X ^ 13 + C ((-3262453970316 / 275112497 : ℚ)) * X ^ 14 + C ((-2781666194902 / 275112497 : ℚ)) * X ^ 15 + C ((-1939959711796 / 275112497 : ℚ)) * X ^ 16 + C ((-1419458073424 / 275112497 : ℚ)) * X ^ 17 + C ((-561140748284 / 275112497 : ℚ)) * X ^ 18
theorem UP45_pre_eq :
    UB_0_1_re * UP45_Fre - UB_0_1_im * UP45_Fim = UP45_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP45_Fre, UP45_Fim, UP45_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP45_pim_eq :
    UB_0_1_re * UP45_Fim + UB_0_1_im * UP45_Fre = UP45_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP45_Fre, UP45_Fim, UP45_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP45_mul : UB_0_1 * UP45_F = ofLadj UP45_pre UP45_pim := by
  rw [UB_0_1, UP45_F, ofLadj_mul, UP45_pre_eq, UP45_pim_eq]

def UP46_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def UP46_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def UP46_F : Ki := ofLadj UP46_Fre UP46_Fim
def UP46_pre : Polynomial ℚ := C ((-1392821642224 / 825337491 : ℚ)) + C ((-6938542750944 / 275112497 : ℚ)) * X + C ((-13716925329612 / 275112497 : ℚ)) * X ^ 2 + C ((-6138097264100 / 75030681 : ℚ)) * X ^ 3 + C ((-33608659747968 / 275112497 : ℚ)) * X ^ 4 + C ((-39973097572600 / 275112497 : ℚ)) * X ^ 5 + C ((-135824458924868 / 825337491 : ℚ)) * X ^ 6 + C ((-48383784983104 / 275112497 : ℚ)) * X ^ 7 + C ((-138357430367320 / 825337491 : ℚ)) * X ^ 8 + C ((-136772548114636 / 825337491 : ℚ)) * X ^ 9 + C ((-135601386862724 / 825337491 : ℚ)) * X ^ 10 + C ((-12158114176232 / 75030681 : ℚ)) * X ^ 11 + C ((-114785758609892 / 825337491 : ℚ)) * X ^ 12 + C ((-95621772125800 / 825337491 : ℚ)) * X ^ 13 + C ((-23612786820740 / 275112497 : ℚ)) * X ^ 14 + C ((-12985686832684 / 275112497 : ℚ)) * X ^ 15 + C ((-57090197420 / 2273657 : ℚ)) * X ^ 16 + C ((-4818575456392 / 825337491 : ℚ)) * X ^ 17 + C ((1789438402452 / 275112497 : ℚ)) * X ^ 18
def UP46_pim : Polynomial ℚ := C ((14207330478112 / 825337491 : ℚ)) + C ((28414660956224 / 825337491 : ℚ)) * X + C ((11063387883684 / 275112497 : ℚ)) * X ^ 2 + C ((13363232046772 / 275112497 : ℚ)) * X ^ 3 + C ((10215436376016 / 275112497 : ℚ)) * X ^ 4 + C ((12001129887728 / 825337491 : ℚ)) * X ^ 5 + C ((-1097824442580 / 275112497 : ℚ)) * X ^ 6 + C ((-26211923180056 / 825337491 : ℚ)) * X ^ 7 + C ((-13175370760648 / 275112497 : ℚ)) * X ^ 8 + C ((-39284175498196 / 825337491 : ℚ)) * X ^ 9 + C ((-38258037043076 / 825337491 : ℚ)) * X ^ 10 + C ((-50945680032872 / 825337491 : ℚ)) * X ^ 11 + C ((-63633323022668 / 825337491 : ℚ)) * X ^ 12 + C ((-67382687262376 / 825337491 : ℚ)) * X ^ 13 + C ((-74040282967892 / 825337491 : ℚ)) * X ^ 14 + C ((-21758606063684 / 275112497 : ℚ)) * X ^ 15 + C ((-15979412006468 / 275112497 : ℚ)) * X ^ 16 + C ((-34246119650104 / 825337491 : ℚ)) * X ^ 17 + C ((-12635266866460 / 825337491 : ℚ)) * X ^ 18
theorem UP46_pre_eq :
    UB_0_1_re * UP46_Fre - UB_0_1_im * UP46_Fim = UP46_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP46_Fre, UP46_Fim, UP46_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP46_pim_eq :
    UB_0_1_re * UP46_Fim + UB_0_1_im * UP46_Fre = UP46_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP46_Fre, UP46_Fim, UP46_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP46_mul : UB_0_1 * UP46_F = ofLadj UP46_pre UP46_pim := by
  rw [UB_0_1, UP46_F, ofLadj_mul, UP46_pre_eq, UP46_pim_eq]

def UP47_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def UP47_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def UP47_F : Ki := ofLadj UP47_Fre UP47_Fim
def UP47_pre : Polynomial ℚ := C ((-38327671666 / 825337491 : ℚ)) + C ((247805098248 / 275112497 : ℚ)) * X + C ((1579449694982 / 825337491 : ℚ)) * X ^ 2 + C ((901366504480 / 275112497 : ℚ)) * X ^ 3 + C ((1437075668422 / 275112497 : ℚ)) * X ^ 4 + C ((5573731588850 / 825337491 : ℚ)) * X ^ 5 + C ((6571312213742 / 825337491 : ℚ)) * X ^ 6 + C ((623415183554 / 75030681 : ℚ)) * X ^ 7 + C ((6199571130314 / 825337491 : ℚ)) * X ^ 8 + C ((1910878118596 / 275112497 : ℚ)) * X ^ 9 + C ((489041069596 / 75030681 : ℚ)) * X ^ 10 + C ((5281941045724 / 825337491 : ℚ)) * X ^ 11 + C ((4636036470812 / 825337491 : ℚ)) * X ^ 12 + C ((4153184660806 / 825337491 : ℚ)) * X ^ 13 + C ((3495471616874 / 825337491 : ℚ)) * X ^ 14 + C ((2313769790036 / 825337491 : ℚ)) * X ^ 15 + C ((1306319056874 / 825337491 : ℚ)) * X ^ 16 + C ((308738431982 / 825337491 : ℚ)) * X ^ 17 + C ((-232570223792 / 825337491 : ℚ)) * X ^ 18
def UP47_pim : Polynomial ℚ := C ((-799460668582 / 825337491 : ℚ)) + C ((-1598921337164 / 825337491 : ℚ)) * X + C ((-658364801698 / 275112497 : ℚ)) * X ^ 2 + C ((-2519261156968 / 825337491 : ℚ)) * X ^ 3 + C ((-2461182452590 / 825337491 : ℚ)) * X ^ 4 + C ((-581172828978 / 275112497 : ℚ)) * X ^ 5 + C ((-246657025170 / 275112497 : ℚ)) * X ^ 6 + C ((212163052722 / 275112497 : ℚ)) * X ^ 7 + C ((465020541046 / 275112497 : ℚ)) * X ^ 8 + C ((1326319793444 / 825337491 : ℚ)) * X ^ 9 + C ((1020367910944 / 825337491 : ℚ)) * X ^ 10 + C ((1368129286508 / 825337491 : ℚ)) * X ^ 11 + C ((571963554024 / 275112497 : ℚ)) * X ^ 12 + C ((595370615834 / 275112497 : ℚ)) * X ^ 13 + C ((753845589894 / 275112497 : ℚ)) * X ^ 14 + C ((2400889781992 / 825337491 : ℚ)) * X ^ 15 + C ((2075483582906 / 825337491 : ℚ)) * X ^ 16 + C ((515114405130 / 275112497 : ℚ)) * X ^ 17 + C ((561140748284 / 825337491 : ℚ)) * X ^ 18
theorem UP47_pre_eq :
    UB_0_1_re * UP47_Fre - UB_0_1_im * UP47_Fim = UP47_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP47_Fre, UP47_Fim, UP47_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP47_pim_eq :
    UB_0_1_re * UP47_Fim + UB_0_1_im * UP47_Fre = UP47_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_0_1_re, UB_0_1_im, UP47_Fre, UP47_Fim, UP47_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP47_mul : UB_0_1 * UP47_F = ofLadj UP47_pre UP47_pim := by
  rw [UB_0_1, UP47_F, ofLadj_mul, UP47_pre_eq, UP47_pim_eq]

def UP48_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP48_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP48_F : Ki := ofLadj UP48_Fre UP48_Fim
def UP48_pre : Polynomial ℚ := C ((-42191817130 / 825337491 : ℚ)) + C ((4169448003568 / 275112497 : ℚ)) * X + C ((25096746203869 / 825337491 : ℚ)) * X ^ 2 + C ((13617708968168 / 275112497 : ℚ)) * X ^ 3 + C ((22997188427460 / 275112497 : ℚ)) * X ^ 4 + C ((29464427506842 / 275112497 : ℚ)) * X ^ 5 + C ((106509075877808 / 825337491 : ℚ)) * X ^ 6 + C ((38156431980373 / 275112497 : ℚ)) * X ^ 7 + C ((35526783019362 / 275112497 : ℚ)) * X ^ 8 + C ((33627984777624 / 275112497 : ℚ)) * X ^ 9 + C ((32199601170293 / 275112497 : ℚ)) * X ^ 10 + C ((94986410380610 / 825337491 : ℚ)) * X ^ 11 + C ((28030153166725 / 275112497 : ℚ)) * X ^ 12 + C ((75787208129003 / 825337491 : ℚ)) * X ^ 13 + C ((1991734004654 / 25010227 : ℚ)) * X ^ 14 + C ((14256821862874 / 275112497 : ℚ)) * X ^ 15 + C ((8824950126752 / 275112497 : ℚ)) * X ^ 16 + C ((8359057022974 / 825337491 : ℚ)) * X ^ 17 + C ((-902421690039 / 275112497 : ℚ)) * X ^ 18
def UP48_pim : Polynomial ℚ := C ((-11850308957882 / 825337491 : ℚ)) + C ((-23700617915764 / 825337491 : ℚ)) * X + C ((-30692665818721 / 825337491 : ℚ)) * X ^ 2 + C ((-42010491507388 / 825337491 : ℚ)) * X ^ 3 + C ((-14105782332183 / 275112497 : ℚ)) * X ^ 4 + C ((-10343729794097 / 275112497 : ℚ)) * X ^ 5 + C ((-6178182665488 / 275112497 : ℚ)) * X ^ 6 + C ((5313314932799 / 825337491 : ℚ)) * X ^ 7 + C ((6125816551078 / 275112497 : ℚ)) * X ^ 8 + C ((17534891557567 / 825337491 : ℚ)) * X ^ 9 + C ((4601895957840 / 275112497 : ℚ)) * X ^ 10 + C ((6719839112956 / 275112497 : ℚ)) * X ^ 11 + C ((8837782268072 / 275112497 : ℚ)) * X ^ 12 + C ((29776191023126 / 825337491 : ℚ)) * X ^ 13 + C ((13417152872042 / 275112497 : ℚ)) * X ^ 14 + C ((14323827381297 / 275112497 : ℚ)) * X ^ 15 + C ((36457793141699 / 825337491 : ℚ)) * X ^ 16 + C ((9908786999676 / 275112497 : ℚ)) * X ^ 17 + C ((3550322227277 / 275112497 : ℚ)) * X ^ 18
theorem UP48_pre_eq :
    UB_2_0_re * UP48_Fre - UB_2_0_im * UP48_Fim = UP48_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP48_Fre, UP48_Fim, UP48_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP48_pim_eq :
    UB_2_0_re * UP48_Fim + UB_2_0_im * UP48_Fre = UP48_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP48_Fre, UP48_Fim, UP48_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP48_mul : UB_2_0 * UP48_F = ofLadj UP48_pre UP48_pim := by
  rw [UB_2_0, UP48_F, ofLadj_mul, UP48_pre_eq, UP48_pim_eq]

def UP49_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def UP49_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def UP49_F : Ki := ofLadj UP49_Fre UP49_Fim
def UP49_pre : Polynomial ℚ := C ((241794888608 / 825337491 : ℚ)) + C ((20847240017840 / 275112497 : ℚ)) * X + C ((118853230592476 / 825337491 : ℚ)) * X ^ 2 + C ((68112889871860 / 275112497 : ℚ)) * X ^ 3 + C ((111079483863818 / 275112497 : ℚ)) * X ^ 4 + C ((430323200601634 / 825337491 : ℚ)) * X ^ 5 + C ((524127617715422 / 825337491 : ℚ)) * X ^ 6 + C ((200121894026102 / 275112497 : ℚ)) * X ^ 7 + C ((55485799065406 / 75030681 : ℚ)) * X ^ 8 + C ((631772397839326 / 825337491 : ℚ)) * X ^ 9 + C ((215950345756698 / 275112497 : ℚ)) * X ^ 10 + C ((653857556719012 / 825337491 : ℚ)) * X ^ 11 + C ((195103105738858 / 275112497 : ℚ)) * X ^ 12 + C ((170973055748950 / 275112497 : ℚ)) * X ^ 13 + C ((406005120103886 / 825337491 : ℚ)) * X ^ 14 + C ((257647061657840 / 825337491 : ℚ)) * X ^ 15 + C ((148881872926220 / 825337491 : ℚ)) * X ^ 16 + C ((55077455812432 / 825337491 : ℚ)) * X ^ 17 + C ((-9480168829012 / 825337491 : ℚ)) * X ^ 18
def UP49_pim : Polynomial ℚ := C ((-57688001788072 / 825337491 : ℚ)) + C ((-115376003576144 / 825337491 : ℚ)) * X + C ((-14197947002512 / 75030681 : ℚ)) * X ^ 2 + C ((-218834987211748 / 825337491 : ℚ)) * X ^ 3 + C ((-229448545846882 / 825337491 : ℚ)) * X ^ 4 + C ((-203620475796134 / 825337491 : ℚ)) * X ^ 5 + C ((-59521832281658 / 275112497 : ℚ)) * X ^ 6 + C ((-35383036749218 / 275112497 : ℚ)) * X ^ 7 + C ((-54153291397174 / 825337491 : ℚ)) * X ^ 8 + C ((-50968984001174 / 825337491 : ℚ)) * X ^ 9 + C ((-12322219885282 / 275112497 : ℚ)) * X ^ 10 + C ((13794317547832 / 275112497 : ℚ)) * X ^ 11 + C ((39910854980946 / 275112497 : ℚ)) * X ^ 12 + C ((174536302739654 / 825337491 : ℚ)) * X ^ 13 + C ((80126060106590 / 275112497 : ℚ)) * X ^ 14 + C ((241898269683068 / 825337491 : ℚ)) * X ^ 15 + C ((198163075807780 / 825337491 : ℚ)) * X ^ 16 + C ((151412798544176 / 825337491 : ℚ)) * X ^ 17 + C ((20363096040772 / 275112497 : ℚ)) * X ^ 18
theorem UP49_pre_eq :
    UB_2_0_re * UP49_Fre - UB_2_0_im * UP49_Fim = UP49_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP49_Fre, UP49_Fim, UP49_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP49_pim_eq :
    UB_2_0_re * UP49_Fim + UB_2_0_im * UP49_Fre = UP49_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP49_Fre, UP49_Fim, UP49_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP49_mul : UB_2_0 * UP49_F = ofLadj UP49_pre UP49_pim := by
  rw [UB_2_0, UP49_F, ofLadj_mul, UP49_pre_eq, UP49_pim_eq]

def UP50_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP50_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP50_F : Ki := ofLadj UP50_Fre UP50_Fim
def UP50_pre : Polynomial ℚ := C ((3179556420792 / 275112497 : ℚ)) + C ((41694480035680 / 275112497 : ℚ)) * X + C ((255050525535844 / 825337491 : ℚ)) * X ^ 2 + C ((139618528680160 / 275112497 : ℚ)) * X ^ 3 + C ((207758265819068 / 275112497 : ℚ)) * X ^ 4 + C ((741226122810920 / 825337491 : ℚ)) * X ^ 5 + C ((278411276542424 / 275112497 : ℚ)) * X ^ 6 + C ((295844161860364 / 275112497 : ℚ)) * X ^ 7 + C ((845549752168052 / 825337491 : ℚ)) * X ^ 8 + C ((829588069568674 / 825337491 : ℚ)) * X ^ 9 + C ((272457646286640 / 275112497 : ℚ)) * X ^ 10 + C ((73027918927772 / 75030681 : ℚ)) * X ^ 11 + C ((230763166250960 / 275112497 : ℚ)) * X ^ 12 + C ((191512514677610 / 275112497 : ℚ)) * X ^ 13 + C ((426694166127572 / 825337491 : ℚ)) * X ^ 14 + C ((78988847875204 / 275112497 : ℚ)) * X ^ 15 + C ((127735644803852 / 825337491 : ℚ)) * X ^ 16 + C ((33727937987500 / 825337491 : ℚ)) * X ^ 17 + C ((-9097048166092 / 275112497 : ℚ)) * X ^ 18
def UP50_pim : Polynomial ℚ := C ((-84105143549384 / 825337491 : ℚ)) + C ((-168210287098768 / 825337491 : ℚ)) * X + C ((-199922499025372 / 825337491 : ℚ)) * X ^ 2 + C ((-234763038313168 / 825337491 : ℚ)) * X ^ 3 + C ((-176947782621760 / 825337491 : ℚ)) * X ^ 4 + C ((-60982964202548 / 825337491 : ℚ)) * X ^ 5 + C ((10562569968680 / 275112497 : ℚ)) * X ^ 6 + C ((55844045236524 / 275112497 : ℚ)) * X ^ 7 + C ((81967336370364 / 275112497 : ℚ)) * X ^ 8 + C ((243618036194738 / 825337491 : ℚ)) * X ^ 9 + C ((233039953965472 / 825337491 : ℚ)) * X ^ 10 + C ((100553975158104 / 275112497 : ℚ)) * X ^ 11 + C ((370283896983152 / 825337491 : ℚ)) * X ^ 12 + C ((391418026680490 / 825337491 : ℚ)) * X ^ 13 + C ((141324864350644 / 275112497 : ℚ)) * X ^ 14 + C ((372848320490776 / 825337491 : ℚ)) * X ^ 15 + C ((270479759258872 / 825337491 : ℚ)) * X ^ 16 + C ((64643019629164 / 275112497 : ℚ)) * X ^ 17 + C ((71680890271268 / 825337491 : ℚ)) * X ^ 18
theorem UP50_pre_eq :
    UB_2_0_re * UP50_Fre - UB_2_0_im * UP50_Fim = UP50_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP50_Fre, UP50_Fim, UP50_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP50_pim_eq :
    UB_2_0_re * UP50_Fim + UB_2_0_im * UP50_Fre = UP50_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP50_Fre, UP50_Fim, UP50_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP50_mul : UB_2_0 * UP50_F = ofLadj UP50_pre UP50_pim := by
  rw [UB_2_0, UP50_F, ofLadj_mul, UP50_pre_eq, UP50_pim_eq]

def UP51_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def UP51_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def UP51_F : Ki := ofLadj UP51_Fre UP51_Fim
def UP51_pre : Polynomial ℚ := C ((-1316070105644 / 275112497 : ℚ)) + C ((-12508344010704 / 275112497 : ℚ)) * X + C ((-21830566519418 / 275112497 : ℚ)) * X ^ 2 + C ((-35228622335460 / 275112497 : ℚ)) * X ^ 3 + C ((-53181024104344 / 275112497 : ℚ)) * X ^ 4 + C ((-60544185422058 / 275112497 : ℚ)) * X ^ 5 + C ((-69360410951968 / 275112497 : ℚ)) * X ^ 6 + C ((-79646437864288 / 275112497 : ℚ)) * X ^ 7 + C ((-81548900314906 / 275112497 : ℚ)) * X ^ 8 + C ((-87912458906518 / 275112497 : ℚ)) * X ^ 9 + C ((-92772870841368 / 275112497 : ℚ)) * X ^ 10 + C ((-93267778594608 / 275112497 : ℚ)) * X ^ 11 + C ((-7296775166424 / 25010227 : ℚ)) * X ^ 12 + C ((-66081892387100 / 275112497 : ℚ)) * X ^ 13 + C ((-46320277979446 / 275112497 : ℚ)) * X ^ 14 + C ((-22518504136924 / 275112497 : ℚ)) * X ^ 15 + C ((-11678612184594 / 275112497 : ℚ)) * X ^ 16 + C ((-2862386654684 / 275112497 : ℚ)) * X ^ 17 + C ((3946909623020 / 275112497 : ℚ)) * X ^ 18
def UP51_pim : Polynomial ℚ := C ((7159679953868 / 275112497 : ℚ)) + C ((14319359907736 / 275112497 : ℚ)) * X + C ((16534765444942 / 275112497 : ℚ)) * X ^ 2 + C ((1942491532492 / 25010227 : ℚ)) * X ^ 3 + C ((16115109496874 / 275112497 : ℚ)) * X ^ 4 + C ((7207482606316 / 275112497 : ℚ)) * X ^ 5 + C ((4808299700442 / 275112497 : ℚ)) * X ^ 6 + C ((-4176316488046 / 275112497 : ℚ)) * X ^ 7 + C ((-11086177085146 / 275112497 : ℚ)) * X ^ 8 + C ((-12000556889768 / 275112497 : ℚ)) * X ^ 9 + C ((-16211182642768 / 275112497 : ℚ)) * X ^ 10 + C ((-2685525031536 / 25010227 : ℚ)) * X ^ 11 + C ((-42870368051024 / 275112497 : ℚ)) * X ^ 12 + C ((-49296399341230 / 275112497 : ℚ)) * X ^ 13 + C ((-55043420558322 / 275112497 : ℚ)) * X ^ 14 + C ((-47121050234524 / 275112497 : ℚ)) * X ^ 15 + C ((-32803311214274 / 275112497 : ℚ)) * X ^ 16 + C ((-23974661878540 / 275112497 : ℚ)) * X ^ 17 + C ((-9579933560360 / 275112497 : ℚ)) * X ^ 18
theorem UP51_pre_eq :
    UB_2_0_re * UP51_Fre - UB_2_0_im * UP51_Fim = UP51_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP51_Fre, UP51_Fim, UP51_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP51_pim_eq :
    UB_2_0_re * UP51_Fim + UB_2_0_im * UP51_Fre = UP51_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP51_Fre, UP51_Fim, UP51_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP51_mul : UB_2_0 * UP51_F = ofLadj UP51_pre UP51_pim := by
  rw [UB_2_0, UP51_F, ofLadj_mul, UP51_pre_eq, UP51_pim_eq]

def UP52_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def UP52_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def UP52_F : Ki := ofLadj UP52_Fre UP52_Fim
def UP52_pre : Polynomial ℚ := C ((-25983867575840 / 825337491 : ℚ)) + C ((-116744544099904 / 275112497 : ℚ)) * X + C ((-696473755547288 / 825337491 : ℚ)) * X ^ 2 + C ((-1140519293516024 / 825337491 : ℚ)) * X ^ 3 + C ((-1699914469970636 / 825337491 : ℚ)) * X ^ 4 + C ((-2026286126927708 / 825337491 : ℚ)) * X ^ 5 + C ((-763426121761016 / 275112497 : ℚ)) * X ^ 6 + C ((-816988649051412 / 275112497 : ℚ)) * X ^ 7 + C ((-2335487080144748 / 825337491 : ℚ)) * X ^ 8 + C ((-2309272004932072 / 825337491 : ℚ)) * X ^ 9 + C ((-762976747934336 / 275112497 : ℚ)) * X ^ 10 + C ((-2255659096581760 / 825337491 : ℚ)) * X ^ 11 + C ((-646232203834432 / 275112497 : ℚ)) * X ^ 12 + C ((-146618022671344 / 75030681 : ℚ)) * X ^ 13 + C ((-398322595542908 / 275112497 : ℚ)) * X ^ 14 + C ((-659935332991276 / 825337491 : ℚ)) * X ^ 15 + C ((-115970235485072 / 275112497 : ℚ)) * X ^ 16 + C ((-83918468099876 / 825337491 : ℚ)) * X ^ 17 + C ((30372048064108 / 275112497 : ℚ)) * X ^ 18
def UP52_pim : Polynomial ℚ := C ((237996070740416 / 825337491 : ℚ)) + C ((475992141480832 / 825337491 : ℚ)) * X + C ((186484634199368 / 275112497 : ℚ)) * X ^ 2 + C ((223206496375688 / 275112497 : ℚ)) * X ^ 3 + C ((514825409923916 / 825337491 : ℚ)) * X ^ 4 + C ((196898861004220 / 825337491 : ℚ)) * X ^ 5 + C ((-61141637589044 / 825337491 : ℚ)) * X ^ 6 + C ((-446800381417868 / 825337491 : ℚ)) * X ^ 7 + C ((-673404982838480 / 825337491 : ℚ)) * X ^ 8 + C ((-20295689216852 / 25010227 : ℚ)) * X ^ 9 + C ((-217403592862664 / 275112497 : ℚ)) * X ^ 10 + C ((-288222247248400 / 275112497 : ℚ)) * X ^ 11 + C ((-359040901634136 / 275112497 : ℚ)) * X ^ 12 + C ((-1143037500451556 / 825337491 : ℚ)) * X ^ 13 + C ((-416518616099384 / 275112497 : ℚ)) * X ^ 14 + C ((-1105649253976084 / 825337491 : ℚ)) * X ^ 15 + C ((-810354840948244 / 825337491 : ℚ)) * X ^ 16 + C ((-17537688620500 / 25010227 : ℚ)) * X ^ 17 + C ((-215717116539532 / 825337491 : ℚ)) * X ^ 18
theorem UP52_pre_eq :
    UB_2_0_re * UP52_Fre - UB_2_0_im * UP52_Fim = UP52_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP52_Fre, UP52_Fim, UP52_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP52_pim_eq :
    UB_2_0_re * UP52_Fim + UB_2_0_im * UP52_Fre = UP52_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP52_Fre, UP52_Fim, UP52_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP52_mul : UB_2_0 * UP52_F = ofLadj UP52_pre UP52_pim := by
  rw [UB_2_0, UP52_F, ofLadj_mul, UP52_pre_eq, UP52_pim_eq]

def UP53_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def UP53_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def UP53_F : Ki := ofLadj UP53_Fre UP53_Fim
def UP53_pre : Polynomial ℚ := C ((-494945791388 / 825337491 : ℚ)) + C ((4169448003568 / 275112497 : ℚ)) * X + C ((2435376793730 / 75030681 : ℚ)) * X ^ 2 + C ((45718193711152 / 825337491 : ℚ)) * X ^ 3 + C ((601204465484 / 6820971 : ℚ)) * X ^ 4 + C ((94170908151832 / 825337491 : ℚ)) * X ^ 5 + C ((110826739586788 / 825337491 : ℚ)) * X ^ 6 + C ((38613650123874 / 275112497 : ℚ)) * X ^ 7 + C ((104674950293464 / 825337491 : ℚ)) * X ^ 8 + C ((32284922626878 / 275112497 : ℚ)) * X ^ 9 + C ((90842056906450 / 825337491 : ℚ)) * X ^ 10 + C ((89131265639360 / 825337491 : ℚ)) * X ^ 11 + C ((7121246626886 / 75030681 : ℚ)) * X ^ 12 + C ((70065623149604 / 825337491 : ℚ)) * X ^ 13 + C ((19652252194104 / 275112497 : ℚ)) * X ^ 14 + C ((39148300425038 / 825337491 : ℚ)) * X ^ 15 + C ((7332502398482 / 275112497 : ℚ)) * X ^ 16 + C ((1780558586830 / 275112497 : ℚ)) * X ^ 17 + C ((-3946909623020 / 825337491 : ℚ)) * X ^ 18
def UP53_pim : Polynomial ℚ := C ((-13413851959220 / 825337491 : ℚ)) + C ((-26827703918440 / 825337491 : ℚ)) * X + C ((-33327241941530 / 825337491 : ℚ)) * X ^ 2 + C ((-42198657683480 / 825337491 : ℚ)) * X ^ 3 + C ((-41421340046386 / 825337491 : ℚ)) * X ^ 4 + C ((-29139257000630 / 825337491 : ℚ)) * X ^ 5 + C ((-1117815192178 / 75030681 : ℚ)) * X ^ 6 + C ((3643761109842 / 275112497 : ℚ)) * X ^ 7 + C ((23777676794726 / 825337491 : ℚ)) * X ^ 8 + C ((22666995973166 / 825337491 : ℚ)) * X ^ 9 + C ((5822827894220 / 275112497 : ℚ)) * X ^ 10 + C ((7762201113848 / 275112497 : ℚ)) * X ^ 11 + C ((9701574333476 / 275112497 : ℚ)) * X ^ 12 + C ((30405748733012 / 825337491 : ℚ)) * X ^ 13 + C ((38166483653402 / 825337491 : ℚ)) * X ^ 14 + C ((40655625921148 / 825337491 : ℚ)) * X ^ 15 + C ((11687999585918 / 275112497 : ℚ)) * X ^ 16 + C ((8705576040494 / 275112497 : ℚ)) * X ^ 17 + C ((9579933560360 / 825337491 : ℚ)) * X ^ 18
theorem UP53_pre_eq :
    UB_2_0_re * UP53_Fre - UB_2_0_im * UP53_Fim = UP53_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP53_Fre, UP53_Fim, UP53_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP53_pim_eq :
    UB_2_0_re * UP53_Fim + UB_2_0_im * UP53_Fre = UP53_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_2_0_re, UB_2_0_im, UP53_Fre, UP53_Fim, UP53_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP53_mul : UB_2_0 * UP53_F = ofLadj UP53_pre UP53_pim := by
  rw [UB_2_0, UP53_F, ofLadj_mul, UP53_pre_eq, UP53_pim_eq]

def UP54_Fre : Polynomial ℚ := C ((7 / 2 : ℚ)) + C ((3 / 2 : ℚ)) * X ^ 2 + C ((7 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((3 / 2 : ℚ)) * X ^ 5 + C ((3 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((7 / 2 : ℚ)) * X ^ 8 + C ((3 / 2 : ℚ)) * X ^ 9
def UP54_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C ((3 / 2 : ℚ)) * X ^ 3 + C ((5 / 2 : ℚ)) * X ^ 4 + C (-1) * X ^ 5 + C (3) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C (3) * X ^ 9
def UP54_F : Ki := ofLadj UP54_Fre UP54_Fim
def UP54_pre : Polynomial ℚ := C ((5711487834 / 275112497 : ℚ)) + C ((-1277269405712 / 825337491 : ℚ)) * X + C ((-2523874805542 / 825337491 : ℚ)) * X ^ 2 + C ((-4123402905610 / 825337491 : ℚ)) * X ^ 3 + C ((-2329930735938 / 275112497 : ℚ)) * X ^ 4 + C ((-811928431166 / 75030681 : ℚ)) * X ^ 5 + C ((-10800356618264 / 825337491 : ℚ)) * X ^ 6 + C ((-11590217763530 / 825337491 : ℚ)) * X ^ 7 + C ((-10778496374906 / 825337491 : ℚ)) * X ^ 8 + C ((-10213282498514 / 825337491 : ℚ)) * X ^ 9 + C ((-9764097636520 / 825337491 : ℚ)) * X ^ 10 + C ((-9629640647372 / 825337491 : ℚ)) * X ^ 11 + C ((-8486828230808 / 825337491 : ℚ)) * X ^ 12 + C ((-7689407692972 / 825337491 : ℚ)) * X ^ 13 + C ((-6655093469296 / 825337491 : ℚ)) * X ^ 14 + C ((-4323135936128 / 825337491 : ℚ)) * X ^ 15 + C ((-2691972970870 / 825337491 : ℚ)) * X ^ 16 + C ((-274276365144 / 275112497 : ℚ)) * X ^ 17 + C ((92429873196 / 275112497 : ℚ)) * X ^ 18
def UP54_pim : Polynomial ℚ := C ((1213739819978 / 825337491 : ℚ)) + C ((2427479639956 / 825337491 : ℚ)) * X + C ((3125145167752 / 825337491 : ℚ)) * X ^ 2 + C ((4310597061178 / 825337491 : ℚ)) * X ^ 3 + C ((1438451124214 / 275112497 : ℚ)) * X ^ 4 + C ((3185647452322 / 825337491 : ℚ)) * X ^ 5 + C ((1933893334240 / 825337491 : ℚ)) * X ^ 6 + C ((-501375618374 / 825337491 : ℚ)) * X ^ 7 + C ((-596270041282 / 275112497 : ℚ)) * X ^ 8 + C ((-155776850138 / 75030681 : ℚ)) * X ^ 9 + C ((-1328647690954 / 825337491 : ℚ)) * X ^ 10 + C ((-60233733852 / 25010227 : ℚ)) * X ^ 11 + C ((-2646778743278 / 825337491 : ℚ)) * X ^ 12 + C ((-2959546610510 / 825337491 : ℚ)) * X ^ 13 + C ((-1356577910536 / 275112497 : ℚ)) * X ^ 14 + C ((-1435139555570 / 275112497 : ℚ)) * X ^ 15 + C ((-3675197286274 / 825337491 : ℚ)) * X ^ 16 + C ((-997430098188 / 275112497 : ℚ)) * X ^ 17 + C ((-352168627278 / 275112497 : ℚ)) * X ^ 18
theorem UP54_pre_eq :
    UB_1_1_re * UP54_Fre - UB_1_1_im * UP54_Fim = UP54_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP54_Fre, UP54_Fim, UP54_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP54_pim_eq :
    UB_1_1_re * UP54_Fim + UB_1_1_im * UP54_Fre = UP54_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP54_Fre, UP54_Fim, UP54_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP54_mul : UB_1_1 * UP54_F = ofLadj UP54_pre UP54_pim := by
  rw [UB_1_1, UP54_F, ofLadj_mul, UP54_pre_eq, UP54_pim_eq]

def UP55_Fre : Polynomial ℚ := C (17) + C (10) * X ^ 2 + C (16) * X ^ 3 + C (-1) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (-1) * X ^ 7 + C (16) * X ^ 8 + C (10) * X ^ 9
def UP55_Fim : Polynomial ℚ := C (5) + C (10) * X + C (-6) * X ^ 2 + C (10) * X ^ 3 + C (7) * X ^ 4 + C (-2) * X ^ 5 + C (12) * X ^ 6 + C (3) * X ^ 7 + C (16) * X ^ 9
def UP55_F : Ki := ofLadj UP55_Fre UP55_Fim
def UP55_pre : Polynomial ℚ := C ((37607772520 / 825337491 : ℚ)) + C ((-6386347028560 / 825337491 : ℚ)) * X + C ((-11937352475060 / 825337491 : ℚ)) * X ^ 2 + C ((-20633553330296 / 825337491 : ℚ)) * X ^ 3 + C ((-33725904618884 / 825337491 : ℚ)) * X ^ 4 + C ((-43442542187032 / 825337491 : ℚ)) * X ^ 5 + C ((-17701037488788 / 275112497 : ℚ)) * X ^ 6 + C ((-5519359302628 / 75030681 : ℚ)) * X ^ 7 + C ((-61733971223476 / 825337491 : ℚ)) * X ^ 8 + C ((-63853614903800 / 825337491 : ℚ)) * X ^ 9 + C ((-21850107299016 / 275112497 : ℚ)) * X ^ 10 + C ((-22050192786376 / 275112497 : ℚ)) * X ^ 11 + C ((-59163974868488 / 825337491 : ℚ)) * X ^ 12 + C ((-17305420809580 / 275112497 : ℚ)) * X ^ 13 + C ((-41100417893180 / 825337491 : ℚ)) * X ^ 14 + C ((-8665898547992 / 275112497 : ℚ)) * X ^ 15 + C ((-15118375213852 / 825337491 : ℚ)) * X ^ 16 + C ((-5457804934520 / 825337491 : ℚ)) * X ^ 17 + C ((329784022016 / 275112497 : ℚ)) * X ^ 18
def UP55_pim : Polynomial ℚ := C ((1969680141392 / 275112497 : ℚ)) + C ((3939360282784 / 275112497 : ℚ)) * X + C ((15901167101188 / 825337491 : ℚ)) * X ^ 2 + C ((22460205394568 / 825337491 : ℚ)) * X ^ 3 + C ((7788672959652 / 275112497 : ℚ)) * X ^ 4 + C ((20901330406040 / 825337491 : ℚ)) * X ^ 5 + C ((6120016685348 / 275112497 : ℚ)) * X ^ 6 + C ((3683417427748 / 275112497 : ℚ)) * X ^ 7 + C ((5848077572468 / 825337491 : ℚ)) * X ^ 8 + C ((1857326200816 / 275112497 : ℚ)) * X ^ 9 + C ((4121667464512 / 825337491 : ℚ)) * X ^ 10 + C ((-3871536408448 / 825337491 : ℚ)) * X ^ 11 + C ((-3954913427136 / 275112497 : ℚ)) * X ^ 12 + C ((-5799379224060 / 275112497 : ℚ)) * X ^ 13 + C ((-8077758311860 / 275112497 : ℚ)) * X ^ 14 + C ((-24276942395360 / 825337491 : ℚ)) * X ^ 15 + C ((-19927438272284 / 825337491 : ℚ)) * X ^ 16 + C ((-15258934158344 / 825337491 : ℚ)) * X ^ 17 + C ((-2021440245128 / 275112497 : ℚ)) * X ^ 18
theorem UP55_pre_eq :
    UB_1_1_re * UP55_Fre - UB_1_1_im * UP55_Fim = UP55_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP55_Fre, UP55_Fim, UP55_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP55_pim_eq :
    UB_1_1_re * UP55_Fim + UB_1_1_im * UP55_Fre = UP55_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP55_Fre, UP55_Fim, UP55_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP55_mul : UB_1_1 * UP55_F = ofLadj UP55_pre UP55_pim := by
  rw [UB_1_1, UP55_F, ofLadj_mul, UP55_pre_eq, UP55_pim_eq]

def UP56_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP56_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP56_F : Ki := ofLadj UP56_Fre UP56_Fim
def UP56_pre : Polynomial ℚ := C ((-886075354760 / 825337491 : ℚ)) + C ((-12772694057120 / 825337491 : ℚ)) * X + C ((-8591266006240 / 275112497 : ℚ)) * X ^ 2 + C ((-42422097897296 / 825337491 : ℚ)) * X ^ 3 + C ((-21072416277656 / 275112497 : ℚ)) * X ^ 4 + C ((-74983992674864 / 825337491 : ℚ)) * X ^ 5 + C ((-2567908406968 / 25010227 : ℚ)) * X ^ 6 + C ((-29968029627716 / 275112497 : ℚ)) * X ^ 7 + C ((-85650581953108 / 825337491 : ℚ)) * X ^ 8 + C ((-84027272080900 / 825337491 : ℚ)) * X ^ 9 + C ((-82794602098940 / 825337491 : ℚ)) * X ^ 10 + C ((-81441560719208 / 825337491 : ℚ)) * X ^ 11 + C ((-23340636013940 / 275112497 : ℚ)) * X ^ 12 + C ((-58253474062180 / 825337491 : ℚ)) * X ^ 13 + C ((-3929862186892 / 75030681 : ℚ)) * X ^ 14 + C ((-7973031327412 / 275112497 : ℚ)) * X ^ 15 + C ((-1185292053544 / 75030681 : ℚ)) * X ^ 16 + C ((-3281227833904 / 825337491 : ℚ)) * X ^ 17 + C ((83871092968 / 25010227 : ℚ)) * X ^ 18
def UP56_pim : Polynomial ℚ := C ((8624907334072 / 825337491 : ℚ)) + C ((17249814668144 / 825337491 : ℚ)) * X + C ((1854305123800 / 75030681 : ℚ)) * X ^ 2 + C ((24218460632368 / 825337491 : ℚ)) * X ^ 3 + C ((18146135984536 / 825337491 : ℚ)) * X ^ 4 + C ((6574878516656 / 825337491 : ℚ)) * X ^ 5 + C ((-920530557616 / 275112497 : ℚ)) * X ^ 6 + C ((-5519910477108 / 275112497 : ℚ)) * X ^ 7 + C ((-24347226418604 / 825337491 : ℚ)) * X ^ 8 + C ((-24110501130436 / 825337491 : ℚ)) * X ^ 9 + C ((-23041532668612 / 825337491 : ℚ)) * X ^ 10 + C ((-30095287416856 / 825337491 : ℚ)) * X ^ 11 + C ((-37149042165100 / 825337491 : ℚ)) * X ^ 12 + C ((-39227615396932 / 825337491 : ℚ)) * X ^ 13 + C ((-42811994379332 / 825337491 : ℚ)) * X ^ 14 + C ((-37423888967068 / 825337491 : ℚ)) * X ^ 15 + C ((-9074721168728 / 275112497 : ℚ)) * X ^ 16 + C ((-19529883503192 / 825337491 : ℚ)) * X ^ 17 + C ((-2367758583904 / 275112497 : ℚ)) * X ^ 18
theorem UP56_pre_eq :
    UB_1_1_re * UP56_Fre - UB_1_1_im * UP56_Fim = UP56_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP56_Fre, UP56_Fim, UP56_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP56_pim_eq :
    UB_1_1_re * UP56_Fim + UB_1_1_im * UP56_Fre = UP56_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP56_Fre, UP56_Fim, UP56_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP56_mul : UB_1_1 * UP56_F = ofLadj UP56_pre UP56_pim := by
  rw [UB_1_1, UP56_F, ofLadj_mul, UP56_pre_eq, UP56_pim_eq]

def UP57_Fre : Polynomial ℚ := C (-6) + C (-3) * X ^ 2 + C (-6) * X ^ 3 + C (3) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (3) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
def UP57_Fim : Polynomial ℚ := C (-3) + C (-6) * X + C (3) * X ^ 2 + C (-6) * X ^ 3 + C (-3) * X ^ 4 + C (3) * X ^ 5 + C (-9) * X ^ 6 + C (-3) * X ^ 7 + C (-9) * X ^ 9
def UP57_F : Ki := ofLadj UP57_Fre UP57_Fim
def UP57_pre : Polynomial ℚ := C ((127059171468 / 275112497 : ℚ)) + C ((1277269405712 / 275112497 : ℚ)) * X + C ((2204794921716 / 275112497 : ℚ)) * X ^ 2 + C ((3565314690980 / 275112497 : ℚ)) * X ^ 3 + C ((5395723915064 / 275112497 : ℚ)) * X ^ 4 + C ((6113421265236 / 275112497 : ℚ)) * X ^ 5 + C ((7039513154932 / 275112497 : ℚ)) * X ^ 6 + C ((733372635304 / 25010227 : ℚ)) * X ^ 7 + C ((8260362692512 / 275112497 : ℚ)) * X ^ 8 + C ((809648327948 / 25010227 : ℚ)) * X ^ 9 + C ((9398651760364 / 275112497 : ℚ)) * X ^ 10 + C ((9455362398496 / 275112497 : ℚ)) * X ^ 11 + C ((8121382354652 / 275112497 : ℚ)) * X ^ 12 + C ((6701336685712 / 275112497 : ℚ)) * X ^ 13 + C ((4695048001532 / 275112497 : ℚ)) * X ^ 14 + C ((2271703977420 / 275112497 : ℚ)) * X ^ 15 + C ((1201868722608 / 275112497 : ℚ)) * X ^ 16 + C ((275776832912 / 275112497 : ℚ)) * X ^ 17 + C ((-399671095860 / 275112497 : ℚ)) * X ^ 18
def UP57_pim : Polynomial ℚ := C ((-734763792836 / 275112497 : ℚ)) + C ((-1469527585672 / 275112497 : ℚ)) * X + C ((-1685317413552 / 275112497 : ℚ)) * X ^ 2 + C ((-200748011708 / 25010227 : ℚ)) * X ^ 3 + C ((-1647284384788 / 275112497 : ℚ)) * X ^ 4 + C ((-763406986788 / 275112497 : ℚ)) * X ^ 5 + C ((-531509924740 / 275112497 : ℚ)) * X ^ 6 + C ((387374255112 / 275112497 : ℚ)) * X ^ 7 + C ((1065285605572 / 275112497 : ℚ)) * X ^ 8 + C ((1158510812244 / 275112497 : ℚ)) * X ^ 9 + C ((1585739852392 / 275112497 : ℚ)) * X ^ 10 + C ((2945665271400 / 275112497 : ℚ)) * X ^ 11 + C ((4305590690408 / 275112497 : ℚ)) * X ^ 12 + C ((4948609558436 / 275112497 : ℚ)) * X ^ 13 + C ((5564745480344 / 275112497 : ℚ)) * X ^ 14 + C ((4732612879704 / 275112497 : ℚ)) * X ^ 15 + C ((3300424089408 / 275112497 : ℚ)) * X ^ 16 + C ((2416295779248 / 275112497 : ℚ)) * X ^ 17 + C ((949100207100 / 275112497 : ℚ)) * X ^ 18
theorem UP57_pre_eq :
    UB_1_1_re * UP57_Fre - UB_1_1_im * UP57_Fim = UP57_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP57_Fre, UP57_Fim, UP57_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP57_pim_eq :
    UB_1_1_re * UP57_Fim + UB_1_1_im * UP57_Fre = UP57_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP57_Fre, UP57_Fim, UP57_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP57_mul : UB_1_1 * UP57_F = ofLadj UP57_pre UP57_pim := by
  rw [UB_1_1, UP57_F, ofLadj_mul, UP57_pre_eq, UP57_pim_eq]

def UP58_Fre : Polynomial ℚ := C (-68) + C (-22) * X ^ 2 + C (-58) * X ^ 3 + C (14) * X ^ 4 + C (-40) * X ^ 5 + C (-40) * X ^ 6 + C (14) * X ^ 7 + C (-58) * X ^ 8 + C (-22) * X ^ 9
def UP58_Fim : Polynomial ℚ := C (-28) + C (-56) * X + C (12) * X ^ 2 + C (-52) * X ^ 3 + C (-36) * X ^ 4 + C (8) * X ^ 5 + C (-64) * X ^ 6 + C (-20) * X ^ 7 + C (-4) * X ^ 8 + C (-68) * X ^ 9
def UP58_F : Ki := ofLadj UP58_Fre UP58_Fim
def UP58_pre : Polynomial ℚ := C ((801369240448 / 275112497 : ℚ)) + C ((35763543359936 / 825337491 : ℚ)) * X + C ((70357265401304 / 825337491 : ℚ)) * X ^ 2 + C ((115472963209976 / 825337491 : ℚ)) * X ^ 3 + C ((172417246610104 / 825337491 : ℚ)) * X ^ 4 + C ((204932412570664 / 825337491 : ℚ)) * X ^ 5 + C ((77468084803848 / 275112497 : ℚ)) * X ^ 6 + C ((248258315181808 / 825337491 : ℚ)) * X ^ 7 + C ((236611230452984 / 825337491 : ℚ)) * X ^ 8 + C ((77963844890520 / 275112497 : ℚ)) * X ^ 9 + C ((77300945229680 / 275112497 : ℚ)) * X ^ 10 + C ((228674625310000 / 825337491 : ℚ)) * X ^ 11 + C ((196139292329104 / 825337491 : ℚ)) * X ^ 12 + C ((163534269270256 / 825337491 : ℚ)) * X ^ 13 + C ((40379422414336 / 275112497 : ℚ)) * X ^ 14 + C ((22206227254616 / 275112497 : ℚ)) * X ^ 15 + C ((35580784043320 / 825337491 : ℚ)) * X ^ 16 + C ((8108942202440 / 825337491 : ℚ)) * X ^ 17 + C ((-3074128935952 / 275112497 : ℚ)) * X ^ 18
def UP58_pim : Polynomial ℚ := C ((-24405194416544 / 825337491 : ℚ)) + C ((-48810388833088 / 825337491 : ℚ)) * X + C ((-57052401538456 / 825337491 : ℚ)) * X ^ 2 + C ((-69069818522344 / 825337491 : ℚ)) * X ^ 3 + C ((-17572475481488 / 275112497 : ℚ)) * X ^ 4 + C ((-21042218658128 / 825337491 : ℚ)) * X ^ 5 + C ((1664422460904 / 275112497 : ℚ)) * X ^ 6 + C ((44133939494072 / 825337491 : ℚ)) * X ^ 7 + C ((66675731242336 / 825337491 : ℚ)) * X ^ 8 + C ((22083195199800 / 275112497 : ℚ)) * X ^ 9 + C ((5864201974688 / 75030681 : ℚ)) * X ^ 10 + C ((28770145272112 / 275112497 : ℚ)) * X ^ 11 + C ((108114649911104 / 825337491 : ℚ)) * X ^ 12 + C ((38204432912880 / 275112497 : ℚ)) * X ^ 13 + C ((126204570079592 / 825337491 : ℚ)) * X ^ 14 + C ((3364370887536 / 25010227 : ℚ)) * X ^ 15 + C ((27188420731688 / 275112497 : ℚ)) * X ^ 16 + C ((58294171879936 / 825337491 : ℚ)) * X ^ 17 + C ((647567589736 / 25010227 : ℚ)) * X ^ 18
theorem UP58_pre_eq :
    UB_1_1_re * UP58_Fre - UB_1_1_im * UP58_Fim = UP58_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP58_Fre, UP58_Fim, UP58_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP58_pim_eq :
    UB_1_1_re * UP58_Fim + UB_1_1_im * UP58_Fre = UP58_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP58_Fre, UP58_Fim, UP58_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP58_mul : UB_1_1 * UP58_F = ofLadj UP58_pre UP58_pim := by
  rw [UB_1_1, UP58_F, ofLadj_mul, UP58_pre_eq, UP58_pim_eq]

def UP59_Fre : Polynomial ℚ := C (4) + C (1) * X ^ 2 + C (3) * X ^ 3 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (3) * X ^ 8 + C (1) * X ^ 9
def UP59_Fim : Polynomial ℚ := C (1) + C (2) * X + C (-1) * X ^ 2 + C (2) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 6 + C (3) * X ^ 9
def UP59_F : Ki := ofLadj UP59_Fre UP59_Fim
def UP59_pre : Polynomial ℚ := C ((65199008492 / 825337491 : ℚ)) + C ((-1277269405712 / 825337491 : ℚ)) * X + C ((-898106942268 / 275112497 : ℚ)) * X ^ 2 + C ((-4618439634752 / 825337491 : ℚ)) * X ^ 3 + C ((-7368283030864 / 825337491 : ℚ)) * X ^ 4 + C ((-3174772883892 / 275112497 : ℚ)) * X ^ 5 + C ((-340601482052 / 25010227 : ℚ)) * X ^ 6 + C ((-11721810974804 / 825337491 : ℚ)) * X ^ 7 + C ((-10593622564508 / 825337491 : ℚ)) * X ^ 8 + C ((-3264504062516 / 275112497 : ℚ)) * X ^ 9 + C ((-9195782851808 / 825337491 : ℚ)) * X ^ 10 + C ((-3009585359712 / 275112497 : ℚ)) * X ^ 11 + C ((-239954952912 / 25010227 : ℚ)) * X ^ 12 + C ((-2366397120248 / 275112497 : ℚ)) * X ^ 13 + C ((-1991727643252 / 275112497 : ℚ)) * X ^ 14 + C ((-3953856848080 / 825337491 : ℚ)) * X ^ 15 + C ((-2236070041496 / 825337491 : ℚ)) * X ^ 16 + C ((-520539785456 / 825337491 : ℚ)) * X ^ 17 + C ((133223698620 / 275112497 : ℚ)) * X ^ 18
def UP59_pim : Polynomial ℚ := C ((457799498564 / 275112497 : ℚ)) + C ((915598997128 / 275112497 : ℚ)) * X + C ((3392209518200 / 825337491 : ℚ)) * X ^ 2 + C ((4330398945296 / 825337491 : ℚ)) * X ^ 3 + C ((4220299225636 / 825337491 : ℚ)) * X ^ 4 + C ((3003813107480 / 825337491 : ℚ)) * X ^ 5 + C ((431098130516 / 275112497 : ℚ)) * X ^ 6 + C ((-1056427428304 / 825337491 : ℚ)) * X ^ 7 + C ((-213374202296 / 75030681 : ℚ)) * X ^ 8 + C ((-743211245516 / 275112497 : ℚ)) * X ^ 9 + C ((-1706785830940 / 825337491 : ℚ)) * X ^ 10 + C ((-2307030568544 / 825337491 : ℚ)) * X ^ 11 + C ((-969091768716 / 275112497 : ℚ)) * X ^ 12 + C ((-91813331132 / 25010227 : ℚ)) * X ^ 13 + C ((-3850546865744 / 825337491 : ℚ)) * X ^ 14 + C ((-4082035735936 / 825337491 : ℚ)) * X ^ 15 + C ((-1177754838672 / 275112497 : ℚ)) * X ^ 16 + C ((-79730519052 / 25010227 : ℚ)) * X ^ 17 + C ((-316366735700 / 275112497 : ℚ)) * X ^ 18
theorem UP59_pre_eq :
    UB_1_1_re * UP59_Fre - UB_1_1_im * UP59_Fim = UP59_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP59_Fre, UP59_Fim, UP59_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP59_pim_eq :
    UB_1_1_re * UP59_Fim + UB_1_1_im * UP59_Fre = UP59_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UB_1_1_re, UB_1_1_im, UP59_Fre, UP59_Fim, UP59_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP59_mul : UB_1_1 * UP59_F = ofLadj UP59_pre UP59_pim := by
  rw [UB_1_1, UP59_F, ofLadj_mul, UP59_pre_eq, UP59_pim_eq]

def UP60_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def UP60_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def UP60_F : Ki := ofLadj UP60_Fre UP60_Fim
def UP60_pre : Polynomial ℚ := C ((-736314334924 / 825337491 : ℚ)) + C ((-5169402759232 / 825337491 : ℚ)) * X + C ((-9770012592608 / 825337491 : ℚ)) * X ^ 2 + C ((-5124124882648 / 275112497 : ℚ)) * X ^ 3 + C ((-21856729646942 / 825337491 : ℚ)) * X ^ 4 + C ((-50165613348053 / 1650674982 : ℚ)) * X ^ 5 + C ((-27432938786117 / 825337491 : ℚ)) * X ^ 6 + C ((-9518201993185 / 275112497 : ℚ)) * X ^ 7 + C ((-8814120032796 / 275112497 : ℚ)) * X ^ 8 + C ((-26041205449571 / 825337491 : ℚ)) * X ^ 9 + C ((-25736120414090 / 825337491 : ℚ)) * X ^ 10 + C ((-8294539526487 / 275112497 : ℚ)) * X ^ 11 + C ((-20566717654858 / 825337491 : ℚ)) * X ^ 12 + C ((-493066450211 / 25010227 : ℚ)) * X ^ 13 + C ((-3689995150148 / 275112497 : ℚ)) * X ^ 14 + C ((-1651289340383 / 275112497 : ℚ)) * X ^ 15 + C ((-1947094281137 / 825337491 : ℚ)) * X ^ 16 + C ((806075661907 / 1650674982 : ℚ)) * X ^ 17 + C ((1744008311464 / 825337491 : ℚ)) * X ^ 18
def UP60_pim : Polynomial ℚ := C ((2309216937968 / 825337491 : ℚ)) + C ((4618433875936 / 825337491 : ℚ)) * X + C ((1471100307856 / 275112497 : ℚ)) * X ^ 2 + C ((4355887789865 / 825337491 : ℚ)) * X ^ 3 + C ((1166872927370 / 825337491 : ℚ)) * X ^ 4 + C ((-7634513089483 / 1650674982 : ℚ)) * X ^ 5 + C ((-15267926924003 / 1650674982 : ℚ)) * X ^ 6 + C ((-4160024547050 / 275112497 : ℚ)) * X ^ 7 + C ((-30370817467483 / 1650674982 : ℚ)) * X ^ 8 + C ((-30254254066303 / 1650674982 : ℚ)) * X ^ 9 + C ((-14862668250409 / 825337491 : ℚ)) * X ^ 10 + C ((-16782757568824 / 825337491 : ℚ)) * X ^ 11 + C ((-18702846887239 / 825337491 : ℚ)) * X ^ 12 + C ((-301376118217 / 13641942 : ℚ)) * X ^ 13 + C ((-36235120635671 / 1650674982 : ℚ)) * X ^ 14 + C ((-15098077159618 / 825337491 : ℚ)) * X ^ 15 + C ((-1900410199625 / 150061362 : ℚ)) * X ^ 16 + C ((-14087210314063 / 1650674982 : ℚ)) * X ^ 17 + C ((-2535803388314 / 825337491 : ℚ)) * X ^ 18
theorem UP60_pre_eq :
    UC_0_0_re * UP60_Fre - UC_0_0_im * UP60_Fim = UP60_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP60_Fre, UP60_Fim, UP60_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP60_pim_eq :
    UC_0_0_re * UP60_Fim + UC_0_0_im * UP60_Fre = UP60_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP60_Fre, UP60_Fim, UP60_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP60_mul : UC_0_0 * UP60_F = ofLadj UP60_pre UP60_pim := by
  rw [UC_0_0, UP60_F, ofLadj_mul, UP60_pre_eq, UP60_pim_eq]

def UP61_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP61_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP61_F : Ki := ofLadj UP61_Fre UP61_Fim
def UP61_pre : Polynomial ℚ := C ((1006731304984 / 825337491 : ℚ)) + C ((12923506898080 / 825337491 : ℚ)) * X + C ((26390338736138 / 825337491 : ℚ)) * X ^ 2 + C ((14453336969844 / 275112497 : ℚ)) * X ^ 3 + C ((64480928940040 / 825337491 : ℚ)) * X ^ 4 + C ((6972676153606 / 75030681 : ℚ)) * X ^ 5 + C ((86420434323556 / 825337491 : ℚ)) * X ^ 6 + C ((91842672623138 / 825337491 : ℚ)) * X ^ 7 + C ((87487892223023 / 825337491 : ℚ)) * X ^ 8 + C ((85838616552797 / 825337491 : ℚ)) * X ^ 9 + C ((84572804757454 / 825337491 : ℚ)) * X ^ 10 + C ((83096362672948 / 825337491 : ℚ)) * X ^ 11 + C ((23883099286458 / 275112497 : ℚ)) * X ^ 12 + C ((19816092605553 / 275112497 : ℚ)) * X ^ 13 + C ((44127881313491 / 825337491 : ℚ)) * X ^ 14 + C ((8175558696212 / 275112497 : ℚ)) * X ^ 15 + C ((13212609406604 / 825337491 : ℚ)) * X ^ 16 + C ((105806447658 / 25010227 : ℚ)) * X ^ 17 + C ((-2835067594462 / 825337491 : ℚ)) * X ^ 18
def UP61_pim : Polynomial ℚ := C ((-8680831396988 / 825337491 : ℚ)) + C ((-17361662793976 / 825337491 : ℚ)) * X + C ((-20673208775954 / 825337491 : ℚ)) * X ^ 2 + C ((-8076519229026 / 275112497 : ℚ)) * X ^ 3 + C ((-150830100040 / 6820971 : ℚ)) * X ^ 4 + C ((-6246786665536 / 825337491 : ℚ)) * X ^ 5 + C ((3348438035434 / 825337491 : ℚ)) * X ^ 6 + C ((17422672655546 / 825337491 : ℚ)) * X ^ 7 + C ((8515106576419 / 275112497 : ℚ)) * X ^ 8 + C ((8436937781177 / 275112497 : ℚ)) * X ^ 9 + C ((24217950120446 / 825337491 : ℚ)) * X ^ 10 + C ((31295000731144 / 825337491 : ℚ)) * X ^ 11 + C ((12790683780614 / 275112497 : ℚ)) * X ^ 12 + C ((13530244700245 / 275112497 : ℚ)) * X ^ 13 + C ((43912576626133 / 825337491 : ℚ)) * X ^ 14 + C ((12874085171048 / 275112497 : ℚ)) * X ^ 15 + C ((28026723963754 / 825337491 : ℚ)) * X ^ 16 + C ((55371799820 / 2273657 : ℚ)) * X ^ 17 + C ((2477950868154 / 275112497 : ℚ)) * X ^ 18
theorem UP61_pre_eq :
    UC_0_0_re * UP61_Fre - UC_0_0_im * UP61_Fim = UP61_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP61_Fre, UP61_Fim, UP61_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP61_pim_eq :
    UC_0_0_re * UP61_Fim + UC_0_0_im * UP61_Fre = UP61_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP61_Fre, UP61_Fim, UP61_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP61_mul : UC_0_0 * UP61_F = ofLadj UP61_pre UP61_pim := by
  rw [UC_0_0, UP61_F, ofLadj_mul, UP61_pre_eq, UP61_pim_eq]

def UP62_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def UP62_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def UP62_F : Ki := ofLadj UP62_Fre UP62_Fim
def UP62_pre : Polynomial ℚ := C ((1187009285024 / 825337491 : ℚ)) + C ((18092909657312 / 825337491 : ℚ)) * X + C ((12090011207522 / 275112497 : ℚ)) * X ^ 2 + C ((19626180642674 / 275112497 : ℚ)) * X ^ 3 + C ((8122235647276 / 75030681 : ℚ)) * X ^ 4 + C ((108112037609344 / 825337491 : ℚ)) * X ^ 5 + C ((125055275916875 / 825337491 : ℚ)) * X ^ 6 + C ((136468658718457 / 825337491 : ℚ)) * X ^ 7 + C ((12197061007082 / 75030681 : ℚ)) * X ^ 8 + C ((45320648311848 / 275112497 : ℚ)) * X ^ 9 + C ((137344717815229 / 825337491 : ℚ)) * X ^ 10 + C ((45553315774474 / 275112497 : ℚ)) * X ^ 11 + C ((119251808157917 / 825337491 : ℚ)) * X ^ 12 + C ((33230637104326 / 275112497 : ℚ)) * X ^ 13 + C ((75289129149880 / 825337491 : ℚ)) * X ^ 14 + C ((43163228208865 / 825337491 : ℚ)) * X ^ 15 + C ((7806042886495 / 275112497 : ℚ)) * X ^ 16 + C ((6474890351954 / 825337491 : ℚ)) * X ^ 17 + C ((-3960838389556 / 825337491 : ℚ)) * X ^ 18
def UP62_pim : Polynomial ℚ := C ((-12928574369668 / 825337491 : ℚ)) + C ((-25857148739336 / 825337491 : ℚ)) * X + C ((-31635021821434 / 825337491 : ℚ)) * X ^ 2 + C ((-39339547425788 / 825337491 : ℚ)) * X ^ 3 + C ((-11408008389456 / 275112497 : ℚ)) * X ^ 4 + C ((-20473131126310 / 825337491 : ℚ)) * X ^ 5 + C ((-895203859535 / 75030681 : ℚ)) * X ^ 6 + C ((9223624140601 / 825337491 : ℚ)) * X ^ 7 + C ((20325428929438 / 825337491 : ℚ)) * X ^ 8 + C ((20579683026880 / 825337491 : ℚ)) * X ^ 9 + C ((21775756367215 / 825337491 : ℚ)) * X ^ 10 + C ((36446602091696 / 825337491 : ℚ)) * X ^ 11 + C ((17039149272059 / 275112497 : ℚ)) * X ^ 12 + C ((58091394238610 / 825337491 : ℚ)) * X ^ 13 + C ((22016724646802 / 275112497 : ℚ)) * X ^ 14 + C ((60183946119199 / 825337491 : ℚ)) * X ^ 15 + C ((44896428910739 / 825337491 : ℚ)) * X ^ 16 + C ((32460000114512 / 825337491 : ℚ)) * X ^ 17 + C ((3950836784208 / 275112497 : ℚ)) * X ^ 18
theorem UP62_pre_eq :
    UC_0_0_re * UP62_Fre - UC_0_0_im * UP62_Fim = UP62_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP62_Fre, UP62_Fim, UP62_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP62_pim_eq :
    UC_0_0_re * UP62_Fim + UC_0_0_im * UP62_Fre = UP62_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP62_Fre, UP62_Fim, UP62_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP62_mul : UC_0_0 * UP62_F = ofLadj UP62_pre UP62_pim := by
  rw [UC_0_0, UP62_F, ofLadj_mul, UP62_pre_eq, UP62_pim_eq]

def UP63_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def UP63_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def UP63_F : Ki := ofLadj UP63_Fre UP63_Fim
def UP63_pre : Polynomial ℚ := C ((-457451578884 / 275112497 : ℚ)) + C ((-18092909657312 / 825337491 : ℚ)) * X + C ((-36033948819926 / 825337491 : ℚ)) * X ^ 2 + C ((-59038125626272 / 825337491 : ℚ)) * X ^ 3 + C ((-87931660187375 / 825337491 : ℚ)) * X ^ 4 + C ((-104838437713358 / 825337491 : ℚ)) * X ^ 5 + C ((-118485095755973 / 825337491 : ℚ)) * X ^ 6 + C ((-42272046193557 / 275112497 : ℚ)) * X ^ 7 + C ((-120821360245235 / 825337491 : ℚ)) * X ^ 8 + C ((-119472579272840 / 825337491 : ℚ)) * X ^ 9 + C ((-118413147949081 / 825337491 : ℚ)) * X ^ 10 + C ((-38888924488090 / 275112497 : ℚ)) * X ^ 11 + C ((-100320238291769 / 825337491 : ℚ)) * X ^ 12 + C ((-2528443347058 / 25010227 : ℚ)) * X ^ 13 + C ((-5616657692633 / 75030681 : ℚ)) * X ^ 14 + C ((-1034923804049 / 25010227 : ℚ)) * X ^ 15 + C ((-5996602344899 / 275112497 : ℚ)) * X ^ 16 + C ((-1447716330694 / 275112497 : ℚ)) * X ^ 17 + C ((4731992859679 / 825337491 : ℚ)) * X ^ 18
def UP63_pim : Polynomial ℚ := C ((1116581729524 / 75030681 : ℚ)) + C ((2233163459048 / 75030681 : ℚ)) * X + C ((28928728158380 / 825337491 : ℚ)) * X ^ 2 + C ((34555591101478 / 825337491 : ℚ)) * X ^ 3 + C ((8851937153355 / 275112497 : ℚ)) * X ^ 4 + C ((10100868320549 / 825337491 : ℚ)) * X ^ 5 + C ((-1085249208614 / 275112497 : ℚ)) * X ^ 6 + C ((-23237458503340 / 825337491 : ℚ)) * X ^ 7 + C ((-34978254864049 / 825337491 : ℚ)) * X ^ 8 + C ((-34794433230226 / 825337491 : ℚ)) * X ^ 9 + C ((-33887648796293 / 825337491 : ℚ)) * X ^ 10 + C ((-44846881575448 / 825337491 : ℚ)) * X ^ 11 + C ((-18602038118201 / 275112497 : ℚ)) * X ^ 12 + C ((-59263260029522 / 825337491 : ℚ)) * X ^ 13 + C ((-64706301338797 / 825337491 : ℚ)) * X ^ 14 + C ((-19087275879768 / 275112497 : ℚ)) * X ^ 15 + C ((-13994240231534 / 275112497 : ℚ)) * X ^ 16 + C ((-9997121700491 / 275112497 : ℚ)) * X ^ 17 + C ((-3728496806263 / 275112497 : ℚ)) * X ^ 18
theorem UP63_pre_eq :
    UC_0_0_re * UP63_Fre - UC_0_0_im * UP63_Fim = UP63_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP63_Fre, UP63_Fim, UP63_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP63_pim_eq :
    UC_0_0_re * UP63_Fim + UC_0_0_im * UP63_Fre = UP63_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP63_Fre, UP63_Fim, UP63_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP63_mul : UC_0_0 * UP63_F = ofLadj UP63_pre UP63_pim := by
  rw [UC_0_0, UP63_F, ofLadj_mul, UP63_pre_eq, UP63_pim_eq]

def UP64_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def UP64_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def UP64_F : Ki := ofLadj UP64_Fre UP64_Fim
def UP64_pre : Polynomial ℚ := C ((-95206461608 / 825337491 : ℚ)) + C ((2584701379616 / 825337491 : ℚ)) * X + C ((5546623149110 / 825337491 : ℚ)) * X ^ 2 + C ((9470603603192 / 825337491 : ℚ)) * X ^ 3 + C ((15055636522154 / 825337491 : ℚ)) * X ^ 4 + C ((19488487867850 / 825337491 : ℚ)) * X ^ 5 + C ((22935280122164 / 825337491 : ℚ)) * X ^ 6 + C ((23982117775090 / 825337491 : ℚ)) * X ^ 7 + C ((21665615119102 / 825337491 : ℚ)) * X ^ 8 + C ((20045053892968 / 825337491 : ℚ)) * X ^ 9 + C ((18800700776458 / 825337491 : ℚ)) * X ^ 10 + C ((18445399185860 / 825337491 : ℚ)) * X ^ 11 + C ((16215999396842 / 825337491 : ℚ)) * X ^ 12 + C ((14498430743858 / 825337491 : ℚ)) * X ^ 13 + C ((12195011515910 / 825337491 : ℚ)) * X ^ 14 + C ((245652859556 / 25010227 : ℚ)) * X ^ 15 + C ((4553230154650 / 825337491 : ℚ)) * X ^ 16 + C ((1106437900336 / 825337491 : ℚ)) * X ^ 17 + C ((-819936887588 / 825337491 : ℚ)) * X ^ 18
def UP64_pim : Polynomial ℚ := C ((-83940813068 / 25010227 : ℚ)) + C ((-167881626136 / 25010227 : ℚ)) * X + C ((-6894849495986 / 825337491 : ℚ)) * X ^ 2 + C ((-2905794184726 / 275112497 : ℚ)) * X ^ 3 + C ((-777894688490 / 75030681 : ℚ)) * X ^ 4 + C ((-546655497794 / 75030681 : ℚ)) * X ^ 5 + C ((-2532773238878 / 825337491 : ℚ)) * X ^ 6 + C ((2282567316214 / 825337491 : ℚ)) * X ^ 7 + C ((4946738994322 / 825337491 : ℚ)) * X ^ 8 + C ((142914725582 / 25010227 : ℚ)) * X ^ 9 + C ((1211860882906 / 275112497 : ℚ)) * X ^ 10 + C ((1612471462480 / 275112497 : ℚ)) * X ^ 11 + C ((2013082042054 / 275112497 : ℚ)) * X ^ 12 + C ((6313398664172 / 825337491 : ℚ)) * X ^ 13 + C ((7905378672248 / 825337491 : ℚ)) * X ^ 14 + C ((8422020473432 / 825337491 : ℚ)) * X ^ 15 + C ((7266821204824 / 825337491 : ℚ)) * X ^ 16 + C ((5413897622180 / 825337491 : ℚ)) * X ^ 17 + C ((1986988896136 / 825337491 : ℚ)) * X ^ 18
theorem UP64_pre_eq :
    UC_0_0_re * UP64_Fre - UC_0_0_im * UP64_Fim = UP64_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP64_Fre, UP64_Fim, UP64_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP64_pim_eq :
    UC_0_0_re * UP64_Fim + UC_0_0_im * UP64_Fre = UP64_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP64_Fre, UP64_Fim, UP64_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP64_mul : UC_0_0 * UP64_F = ofLadj UP64_pre UP64_pim := by
  rw [UC_0_0, UP64_F, ofLadj_mul, UP64_pre_eq, UP64_pim_eq]

def UP65_Fre : Polynomial ℚ := C (3)
def UP65_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def UP65_F : Ki := ofLadj UP65_Fre UP65_Fim
def UP65_pre : Polynomial ℚ := C ((-92672725814 / 275112497 : ℚ)) + C ((257051490041 / 275112497 : ℚ)) * X ^ 2 + C ((590185111181 / 275112497 : ℚ)) * X ^ 3 + C ((898192965761 / 275112497 : ℚ)) * X ^ 4 + C ((1079362392137 / 275112497 : ℚ)) * X ^ 5 + C ((1079362392137 / 275112497 : ℚ)) * X ^ 6 + C ((898192965761 / 275112497 : ℚ)) * X ^ 7 + C ((590185111181 / 275112497 : ℚ)) * X ^ 8 + C ((257051490041 / 275112497 : ℚ)) * X ^ 9
def UP65_pim : Polynomial ℚ := C ((-323087672452 / 275112497 : ℚ)) + C ((-646175344904 / 275112497 : ℚ)) * X + C ((-868515322849 / 275112497 : ℚ)) * X ^ 2 + C ((-915548888616 / 275112497 : ℚ)) * X ^ 3 + C ((-776886418897 / 275112497 : ℚ)) * X ^ 4 + C ((-490522225203 / 275112497 : ℚ)) * X ^ 5 + C ((-155653119701 / 275112497 : ℚ)) * X ^ 6 + C ((130711073993 / 275112497 : ℚ)) * X ^ 7 + C ((269373543712 / 275112497 : ℚ)) * X ^ 8 + C ((222339977945 / 275112497 : ℚ)) * X ^ 9
theorem UP65_pre_eq :
    UC_0_0_re * UP65_Fre - UC_0_0_im * UP65_Fim = UP65_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP65_Fre, UP65_Fim, UP65_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP65_pim_eq :
    UC_0_0_re * UP65_Fim + UC_0_0_im * UP65_Fre = UP65_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_0_re, UC_0_0_im, UP65_Fre, UP65_Fim, UP65_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP65_mul : UC_0_0 * UP65_F = ofLadj UP65_pre UP65_pim := by
  rw [UC_0_0, UP65_F, ofLadj_mul, UP65_pre_eq, UP65_pim_eq]

def UP66_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def UP66_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def UP66_F : Ki := ofLadj UP66_Fre UP66_Fim
def UP66_pre : Polynomial ℚ := C ((895839372176 / 275112497 : ℚ)) + C ((6178606109952 / 275112497 : ℚ)) * X + C ((11699338763052 / 275112497 : ℚ)) * X ^ 2 + C ((55155795230788 / 825337491 : ℚ)) * X ^ 3 + C ((78357047538916 / 825337491 : ℚ)) * X ^ 4 + C ((30025115600237 / 275112497 : ℚ)) * X ^ 5 + C ((98351362641139 / 825337491 : ℚ)) * X ^ 6 + C ((102476162530969 / 825337491 : ℚ)) * X ^ 7 + C ((31632388034353 / 275112497 : ℚ)) * X ^ 8 + C ((93449650198918 / 825337491 : ℚ)) * X ^ 9 + C ((92363778795250 / 825337491 : ℚ)) * X ^ 10 + C ((89255251281380 / 825337491 : ℚ)) * X ^ 11 + C ((73827960465394 / 825337491 : ℚ)) * X ^ 12 + C ((58351633909762 / 825337491 : ℚ)) * X ^ 13 + C ((3612851715661 / 75030681 : ℚ)) * X ^ 14 + C ((17853037937641 / 825337491 : ℚ)) * X ^ 15 + C ((6924120510823 / 825337491 : ℚ)) * X ^ 16 + C ((-450631776535 / 275112497 : ℚ)) * X ^ 17 + C ((-6266077054412 / 825337491 : ℚ)) * X ^ 18
def UP66_pim : Polynomial ℚ := C ((-8248556184320 / 825337491 : ℚ)) + C ((-16497112368640 / 825337491 : ℚ)) * X + C ((-5271295330980 / 275112497 : ℚ)) * X ^ 2 + C ((-5156468962064 / 275112497 : ℚ)) * X ^ 3 + C ((-4172757154112 / 825337491 : ℚ)) * X ^ 4 + C ((4601774074031 / 275112497 : ℚ)) * X ^ 5 + C ((9173006164569 / 275112497 : ℚ)) * X ^ 6 + C ((44815965574415 / 825337491 : ℚ)) * X ^ 7 + C ((4963444016921 / 75030681 : ℚ)) * X ^ 8 + C ((18127366739534 / 275112497 : ℚ)) * X ^ 9 + C ((53437473350582 / 825337491 : ℚ)) * X ^ 10 + C ((60290588137936 / 825337491 : ℚ)) * X ^ 11 + C ((22381234308430 / 275112497 : ℚ)) * X ^ 12 + C ((65515849681570 / 825337491 : ℚ)) * X ^ 13 + C ((21651862202431 / 275112497 : ℚ)) * X ^ 14 + C ((54272808300473 / 825337491 : ℚ)) * X ^ 15 + C ((37505061471173 / 825337491 : ℚ)) * X ^ 16 + C ((25254661720259 / 825337491 : ℚ)) * X ^ 17 + C ((9168047186456 / 825337491 : ℚ)) * X ^ 18
theorem UP66_pre_eq :
    UC_1_0_re * UP66_Fre - UC_1_0_im * UP66_Fim = UP66_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP66_Fre, UP66_Fim, UP66_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP66_pim_eq :
    UC_1_0_re * UP66_Fim + UC_1_0_im * UP66_Fre = UP66_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP66_Fre, UP66_Fim, UP66_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP66_mul : UC_1_0 * UP66_F = ofLadj UP66_pre UP66_pim := by
  rw [UC_1_0, UP66_F, ofLadj_mul, UP66_pre_eq, UP66_pim_eq]

def UP67_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP67_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP67_F : Ki := ofLadj UP67_Fre UP67_Fim
def UP67_pre : Polynomial ℚ := C ((-1266380197472 / 275112497 : ℚ)) + C ((-15446515274880 / 275112497 : ℚ)) * X + C ((-94908553187044 / 825337491 : ℚ)) * X ^ 2 + C ((-51862969949372 / 275112497 : ℚ)) * X ^ 3 + C ((-231261847107316 / 825337491 : ℚ)) * X ^ 4 + C ((-275460281400212 / 825337491 : ℚ)) * X ^ 5 + C ((-309943167134828 / 825337491 : ℚ)) * X ^ 6 + C ((-329645464694908 / 825337491 : ℚ)) * X ^ 7 + C ((-314034867223540 / 825337491 : ℚ)) * X ^ 8 + C ((-308126676224060 / 825337491 : ℚ)) * X ^ 9 + C ((-303581158456588 / 825337491 : ℚ)) * X ^ 10 + C ((-298117683325096 / 825337491 : ℚ)) * X ^ 11 + C ((-257241612631948 / 825337491 : ℚ)) * X ^ 12 + C ((-213218123037016 / 825337491 : ℚ)) * X ^ 13 + C ((-158445957375424 / 825337491 : ℚ)) * X ^ 14 + C ((-29410760684132 / 275112497 : ℚ)) * X ^ 15 + C ((-15754513047304 / 275112497 : ℚ)) * X ^ 16 + C ((-4260217802432 / 275112497 : ℚ)) * X ^ 17 + C ((3383778511732 / 275112497 : ℚ)) * X ^ 18
def UP67_pim : Polynomial ℚ := C ((31047788271344 / 825337491 : ℚ)) + C ((62095576542688 / 825337491 : ℚ)) * X + C ((74117311755172 / 825337491 : ℚ)) * X ^ 2 + C ((28821532650660 / 275112497 : ℚ)) * X ^ 3 + C ((65440361247956 / 825337491 : ℚ)) * X ^ 4 + C ((7358330164964 / 275112497 : ℚ)) * X ^ 5 + C ((-12372739327156 / 825337491 : ℚ)) * X ^ 6 + C ((-62636312875088 / 825337491 : ℚ)) * X ^ 7 + C ((-30652369988716 / 275112497 : ℚ)) * X ^ 8 + C ((-91119934043752 / 825337491 : ℚ)) * X ^ 9 + C ((-87189692778304 / 825337491 : ℚ)) * X ^ 10 + C ((-112496345039512 / 825337491 : ℚ)) * X ^ 11 + C ((-137802997300720 / 825337491 : ℚ)) * X ^ 12 + C ((-145894491247756 / 825337491 : ℚ)) * X ^ 13 + C ((-14309509229288 / 75030681 : ℚ)) * X ^ 14 + C ((-138848459797856 / 825337491 : ℚ)) * X ^ 15 + C ((-100541404139168 / 825337491 : ℚ)) * X ^ 16 + C ((-72057960564904 / 825337491 : ℚ)) * X ^ 17 + C ((-26852702111348 / 825337491 : ℚ)) * X ^ 18
theorem UP67_pre_eq :
    UC_1_0_re * UP67_Fre - UC_1_0_im * UP67_Fim = UP67_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP67_Fre, UP67_Fim, UP67_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP67_pim_eq :
    UC_1_0_re * UP67_Fim + UC_1_0_im * UP67_Fre = UP67_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP67_Fre, UP67_Fim, UP67_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP67_mul : UC_1_0 * UP67_F = ofLadj UP67_pre UP67_pim := by
  rw [UC_1_0, UP67_F, ofLadj_mul, UP67_pre_eq, UP67_pim_eq]

def UP68_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def UP68_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def UP68_F : Ki := ofLadj UP68_Fre UP68_Fim
def UP68_pre : Polynomial ℚ := C ((-1513407414336 / 275112497 : ℚ)) + C ((-21625121384832 / 275112497 : ℚ)) * X + C ((-43496024732236 / 275112497 : ℚ)) * X ^ 2 + C ((-19210417792084 / 75030681 : ℚ)) * X ^ 3 + C ((-320466147169544 / 825337491 : ℚ)) * X ^ 4 + C ((-388352365674848 / 825337491 : ℚ)) * X ^ 5 + C ((-448546199351384 / 825337491 : ℚ)) * X ^ 6 + C ((-163283581753436 / 275112497 : ℚ)) * X ^ 7 + C ((-481646865305192 / 825337491 : ℚ)) * X ^ 8 + C ((-162683902236180 / 275112497 : ℚ)) * X ^ 9 + C ((-4074690987424 / 6820971 : ℚ)) * X ^ 10 + C ((-163422954827368 / 275112497 : ℚ)) * X ^ 11 + C ((-428162245323808 / 825337491 : ℚ)) * X ^ 12 + C ((-119187877503944 / 275112497 : ℚ)) * X ^ 13 + C ((-90110756530756 / 275112497 : ℚ)) * X ^ 14 + C ((-14110701471380 / 75030681 : ℚ)) * X ^ 15 + C ((-83823877368988 / 825337491 : ℚ)) * X ^ 16 + C ((-23630043692452 / 825337491 : ℚ)) * X ^ 17 + C ((4722293968528 / 275112497 : ℚ)) * X ^ 18
def UP68_pim : Polynomial ℚ := C ((46247276329360 / 825337491 : ℚ)) + C ((92494552658720 / 825337491 : ℚ)) * X + C ((113449560198628 / 825337491 : ℚ)) * X ^ 2 + C ((140483007929428 / 825337491 : ℚ)) * X ^ 3 + C ((40915463969632 / 275112497 : ℚ)) * X ^ 4 + C ((72971699385580 / 825337491 : ℚ)) * X ^ 5 + C ((34773520470376 / 825337491 : ℚ)) * X ^ 6 + C ((-11084002821616 / 275112497 : ℚ)) * X ^ 7 + C ((-73407159214028 / 825337491 : ℚ)) * X ^ 8 + C ((-74292601351504 / 825337491 : ℚ)) * X ^ 9 + C ((-2381462072796 / 25010227 : ℚ)) * X ^ 10 + C ((-131081341935272 / 825337491 : ℚ)) * X ^ 11 + C ((-183574435468276 / 825337491 : ℚ)) * X ^ 12 + C ((-18984099096268 / 75030681 : ℚ)) * X ^ 13 + C ((-21522179993384 / 75030681 : ℚ)) * X ^ 14 + C ((-72118178915080 / 275112497 : ℚ)) * X ^ 15 + C ((-161032176052804 / 825337491 : ℚ)) * X ^ 16 + C ((-38793725004992 / 275112497 : ℚ)) * X ^ 17 + C ((-3891634355512 / 75030681 : ℚ)) * X ^ 18
theorem UP68_pre_eq :
    UC_1_0_re * UP68_Fre - UC_1_0_im * UP68_Fim = UP68_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP68_Fre, UP68_Fim, UP68_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP68_pim_eq :
    UC_1_0_re * UP68_Fim + UC_1_0_im * UP68_Fre = UP68_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP68_Fre, UP68_Fim, UP68_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP68_mul : UC_1_0 * UP68_F = ofLadj UP68_pre UP68_pim := by
  rw [UC_1_0, UP68_F, ofLadj_mul, UP68_pre_eq, UP68_pim_eq]

def UP69_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def UP69_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def UP69_F : Ki := ofLadj UP69_Fre UP69_Fim
def UP69_pre : Polynomial ℚ := C ((5189034398320 / 825337491 : ℚ)) + C ((21625121384832 / 275112497 : ℚ)) * X + C ((129601625414464 / 825337491 : ℚ)) * X ^ 2 + C ((211858390405280 / 825337491 : ℚ)) * X ^ 3 + C ((105117249832130 / 275112497 : ℚ)) * X ^ 4 + C ((125518206213560 / 275112497 : ℚ)) * X ^ 5 + C ((3511606270780 / 6820971 : ℚ)) * X ^ 6 + C ((455191049729228 / 825337491 : ℚ)) * X ^ 7 + C ((433666936937336 / 825337491 : ℚ)) * X ^ 8 + C ((142957695666266 / 275112497 : ℚ)) * X ^ 9 + C ((141672924091280 / 275112497 : ℚ)) * X ^ 10 + C ((418565861052104 / 825337491 : ℚ)) * X ^ 11 + C ((120047802706448 / 275112497 : ℚ)) * X ^ 12 + C ((299271461584334 / 825337491 : ℚ)) * X ^ 13 + C ((611042827912 / 2273657 : ℚ)) * X ^ 14 + C ((122882917804436 / 825337491 : ℚ)) * X ^ 15 + C ((64315143307060 / 825337491 : ℚ)) * X ^ 16 + C ((5321801061120 / 275112497 : ℚ)) * X ^ 17 + C ((-5652127476134 / 275112497 : ℚ)) * X ^ 18
def UP69_pim : Polynomial ℚ := C ((-43930299038128 / 825337491 : ℚ)) + C ((-87860598076256 / 825337491 : ℚ)) * X + C ((-34580349481104 / 275112497 : ℚ)) * X ^ 2 + C ((-123316102602928 / 825337491 : ℚ)) * X ^ 3 + C ((-95260379625970 / 825337491 : ℚ)) * X ^ 4 + C ((-35753706040244 / 825337491 : ℚ)) * X ^ 5 + C ((4055377542624 / 275112497 : ℚ)) * X ^ 6 + C ((27850819401544 / 275112497 : ℚ)) * X ^ 7 + C ((11445953891044 / 75030681 : ℚ)) * X ^ 8 + C ((125287347403226 / 825337491 : ℚ)) * X ^ 9 + C ((40665357956992 / 275112497 : ℚ)) * X ^ 10 + C ((161202046721288 / 825337491 : ℚ)) * X ^ 11 + C ((200408019571600 / 825337491 : ℚ)) * X ^ 12 + C ((70999065468802 / 275112497 : ℚ)) * X ^ 13 + C ((231954105167764 / 825337491 : ℚ)) * X ^ 14 + C ((205842075731032 / 825337491 : ℚ)) * X ^ 15 + C ((50206500179936 / 275112497 : ℚ)) * X ^ 16 + C ((107511568238884 / 825337491 : ℚ)) * X ^ 17 + C ((40409341056626 / 825337491 : ℚ)) * X ^ 18
theorem UP69_pre_eq :
    UC_1_0_re * UP69_Fre - UC_1_0_im * UP69_Fim = UP69_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP69_Fre, UP69_Fim, UP69_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP69_pim_eq :
    UC_1_0_re * UP69_Fim + UC_1_0_im * UP69_Fre = UP69_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP69_Fre, UP69_Fim, UP69_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP69_mul : UC_1_0 * UP69_F = ofLadj UP69_pre UP69_pim := by
  rw [UC_1_0, UP69_F, ofLadj_mul, UP69_pre_eq, UP69_pim_eq]

def UP70_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def UP70_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def UP70_F : Ki := ofLadj UP70_Fre UP70_Fim
def UP70_pre : Polynomial ℚ := C ((278271330016 / 825337491 : ℚ)) + C ((-3089303054976 / 275112497 : ℚ)) * X + C ((-19973833597700 / 825337491 : ℚ)) * X ^ 2 + C ((-33992074494772 / 825337491 : ℚ)) * X ^ 3 + C ((-18004666328944 / 275112497 : ℚ)) * X ^ 4 + C ((-69996206904920 / 825337491 : ℚ)) * X ^ 5 + C ((-27418555641216 / 275112497 : ℚ)) * X ^ 6 + C ((-86078842261636 / 825337491 : ℚ)) * X ^ 7 + C ((-77760650094152 / 825337491 : ℚ)) * X ^ 8 + C ((-6544788143420 / 75030681 : ℚ)) * X ^ 9 + C ((-67492590781744 / 825337491 : ℚ)) * X ^ 10 + C ((-2005403507256 / 25010227 : ℚ)) * X ^ 11 + C ((-5293152874256 / 75030681 : ℚ)) * X ^ 12 + C ((-52018835979920 / 825337491 : ℚ)) * X ^ 13 + C ((-43768575599380 / 825337491 : ℚ)) * X ^ 14 + C ((-882643532788 / 25010227 : ℚ)) * X ^ 15 + C ((-5434636352316 / 275112497 : ℚ)) * X ^ 16 + C ((-4044449038220 / 825337491 : ℚ)) * X ^ 17 + C ((2937606692800 / 825337491 : ℚ)) * X ^ 18
def UP70_pim : Polynomial ℚ := C ((9916721320240 / 825337491 : ℚ)) + C ((19833442640480 / 825337491 : ℚ)) * X + C ((24740681394580 / 825337491 : ℚ)) * X ^ 2 + C ((31154829594476 / 825337491 : ℚ)) * X ^ 3 + C ((10232596667784 / 275112497 : ℚ)) * X ^ 4 + C ((21477048846728 / 825337491 : ℚ)) * X ^ 5 + C ((9014756327224 / 825337491 : ℚ)) * X ^ 6 + C ((-8218896578956 / 825337491 : ℚ)) * X ^ 7 + C ((-5928034115296 / 275112497 : ℚ)) * X ^ 8 + C ((-16989884070212 / 825337491 : ℚ)) * X ^ 9 + C ((-13114711645928 / 825337491 : ℚ)) * X ^ 10 + C ((-17401918967192 / 825337491 : ℚ)) * X ^ 11 + C ((-1971738753496 / 75030681 : ℚ)) * X ^ 12 + C ((-22721192618272 / 825337491 : ℚ)) * X ^ 13 + C ((-28341122542492 / 825337491 : ℚ)) * X ^ 14 + C ((-10090398812220 / 275112497 : ℚ)) * X ^ 15 + C ((-26055757573652 / 825337491 : ℚ)) * X ^ 16 + C ((-6468814298068 / 275112497 : ℚ)) * X ^ 17 + C ((-7178092281640 / 825337491 : ℚ)) * X ^ 18
theorem UP70_pre_eq :
    UC_1_0_re * UP70_Fre - UC_1_0_im * UP70_Fim = UP70_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP70_Fre, UP70_Fim, UP70_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP70_pim_eq :
    UC_1_0_re * UP70_Fim + UC_1_0_im * UP70_Fre = UP70_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP70_Fre, UP70_Fim, UP70_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP70_mul : UC_1_0 * UP70_F = ofLadj UP70_pre UP70_pim := by
  rw [UC_1_0, UP70_F, ofLadj_mul, UP70_pre_eq, UP70_pim_eq]

def UP71_Fre : Polynomial ℚ := C (3)
def UP71_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def UP71_F : Ki := ofLadj UP71_Fre UP71_Fim
def UP71_pre : Polynomial ℚ := C ((324406077656 / 275112497 : ℚ)) + C ((-929833507606 / 275112497 : ℚ)) * X ^ 2 + C ((-2114647777558 / 275112497 : ℚ)) * X ^ 3 + C ((-3224587621248 / 275112497 : ℚ)) * X ^ 4 + C ((-3873854063466 / 275112497 : ℚ)) * X ^ 5 + C ((-3873854063466 / 275112497 : ℚ)) * X ^ 6 + C ((-3224587621248 / 275112497 : ℚ)) * X ^ 7 + C ((-2114647777558 / 275112497 : ℚ)) * X ^ 8 + C ((-929833507606 / 275112497 : ℚ)) * X ^ 9
def UP71_pim : Polynomial ℚ := C ((1158488645616 / 275112497 : ℚ)) + C ((2316977291232 / 275112497 : ℚ)) * X + C ((3116522909234 / 275112497 : ℚ)) * X ^ 2 + C ((3277618551654 / 275112497 : ℚ)) * X ^ 3 + C ((2789169433048 / 275112497 : ℚ)) * X ^ 4 + C ((1755224260502 / 275112497 : ℚ)) * X ^ 5 + C ((561753030730 / 275112497 : ℚ)) * X ^ 6 + C ((-472192141816 / 275112497 : ℚ)) * X ^ 7 + C ((-960641260422 / 275112497 : ℚ)) * X ^ 8 + C ((-799545618002 / 275112497 : ℚ)) * X ^ 9
theorem UP71_pre_eq :
    UC_1_0_re * UP71_Fre - UC_1_0_im * UP71_Fim = UP71_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP71_Fre, UP71_Fim, UP71_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP71_pim_eq :
    UC_1_0_re * UP71_Fim + UC_1_0_im * UP71_Fre = UP71_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_1_0_re, UC_1_0_im, UP71_Fre, UP71_Fim, UP71_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP71_mul : UC_1_0 * UP71_F = ofLadj UP71_pre UP71_pim := by
  rw [UC_1_0, UP71_F, ofLadj_mul, UP71_pre_eq, UP71_pim_eq]

def UP72_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def UP72_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def UP72_F : Ki := ofLadj UP72_Fre UP72_Fim
def UP72_pre : Polynomial ℚ := C ((52485736220 / 275112497 : ℚ)) + C ((377095173344 / 275112497 : ℚ)) * X + C ((713754739348 / 275112497 : ℚ)) * X ^ 2 + C ((3370818037087 / 825337491 : ℚ)) * X ^ 3 + C ((4798743683548 / 825337491 : ℚ)) * X ^ 4 + C ((5503201191838 / 825337491 : ℚ)) * X ^ 5 + C ((6019417150546 / 825337491 : ℚ)) * X ^ 6 + C ((6262702172075 / 825337491 : ℚ)) * X ^ 7 + C ((5799629006741 / 825337491 : ℚ)) * X ^ 8 + C ((5711165666233 / 825337491 : ℚ)) * X ^ 9 + C ((1881403458413 / 275112497 : ℚ)) * X ^ 10 + C ((496493062874 / 75030681 : ℚ)) * X ^ 11 + C ((1504308285069 / 275112497 : ℚ)) * X ^ 12 + C ((3569901448189 / 825337491 : ℚ)) * X ^ 13 + C ((2428810969654 / 825337491 : ℚ)) * X ^ 14 + C ((1081431460523 / 825337491 : ℚ)) * X ^ 15 + C ((141829254099 / 275112497 : ℚ)) * X ^ 16 + C ((-30242732137 / 275112497 : ℚ)) * X ^ 17 + C ((-34775184364 / 75030681 : ℚ)) * X ^ 18
def UP72_pim : Polynomial ℚ := C ((-169269394748 / 275112497 : ℚ)) + C ((-338538789496 / 275112497 : ℚ)) * X + C ((-964022803184 / 825337491 : ℚ)) * X ^ 2 + C ((-953944202245 / 825337491 : ℚ)) * X ^ 3 + C ((-83702514506 / 275112497 : ℚ)) * X ^ 4 + C ((843787934422 / 825337491 : ℚ)) * X ^ 5 + C ((560776767564 / 275112497 : ℚ)) * X ^ 6 + C ((250012973813 / 75030681 : ℚ)) * X ^ 7 + C ((1115650490153 / 275112497 : ℚ)) * X ^ 8 + C ((1111440817391 / 275112497 : ℚ)) * X ^ 9 + C ((3276209896447 / 825337491 : ℚ)) * X ^ 10 + C ((3698418606220 / 825337491 : ℚ)) * X ^ 11 + C ((4120627315993 / 825337491 : ℚ)) * X ^ 12 + C ((4010921194963 / 825337491 : ℚ)) * X ^ 13 + C ((1329404525246 / 275112497 : ℚ)) * X ^ 14 + C ((3322342835743 / 825337491 : ℚ)) * X ^ 15 + C ((2302465008121 / 825337491 : ℚ)) * X ^ 16 + C ((517545866239 / 275112497 : ℚ)) * X ^ 17 + C ((186614279928 / 275112497 : ℚ)) * X ^ 18
theorem UP72_pre_eq :
    UC_0_1_re * UP72_Fre - UC_0_1_im * UP72_Fim = UP72_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP72_Fre, UP72_Fim, UP72_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP72_pim_eq :
    UC_0_1_re * UP72_Fim + UC_0_1_im * UP72_Fre = UP72_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP72_Fre, UP72_Fim, UP72_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP72_mul : UC_0_1 * UP72_F = ofLadj UP72_pre UP72_pim := by
  rw [UC_0_1, UP72_F, ofLadj_mul, UP72_pre_eq, UP72_pim_eq]

def UP73_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP73_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP73_F : Ki := ofLadj UP73_Fre UP73_Fim
def UP73_pre : Polynomial ℚ := C ((-68532254876 / 275112497 : ℚ)) + C ((-942737933360 / 275112497 : ℚ)) * X + C ((-1928208958272 / 275112497 : ℚ)) * X ^ 2 + C ((-9511937601976 / 825337491 : ℚ)) * X ^ 3 + C ((-14160641743400 / 825337491 : ℚ)) * X ^ 4 + C ((-16832252066816 / 825337491 : ℚ)) * X ^ 5 + C ((-18966524455496 / 825337491 : ℚ)) * X ^ 6 + C ((-6717976524052 / 275112497 : ℚ)) * X ^ 7 + C ((-19200231753796 / 825337491 : ℚ)) * X ^ 8 + C ((-6279219782964 / 275112497 : ℚ)) * X ^ 9 + C ((-18559539133676 / 825337491 : ℚ)) * X ^ 10 + C ((-18250866381188 / 825337491 : ℚ)) * X ^ 11 + C ((-15731325333596 / 825337491 : ℚ)) * X ^ 12 + C ((-4351010824692 / 275112497 : ℚ)) * X ^ 13 + C ((-3229431383940 / 275112497 : ℚ)) * X ^ 14 + C ((-162838572128 / 25010227 : ℚ)) * X ^ 15 + C ((-2900623677304 / 825337491 : ℚ)) * X ^ 16 + C ((-766351288624 / 825337491 : ℚ)) * X ^ 17 + C ((619614948532 / 825337491 : ℚ)) * X ^ 18
def UP73_pim : Polynomial ℚ := C ((635289521876 / 275112497 : ℚ)) + C ((1270579043752 / 275112497 : ℚ)) * X + C ((4521387859376 / 825337491 : ℚ)) * X ^ 2 + C ((5310368475856 / 825337491 : ℚ)) * X ^ 3 + C ((3990667233736 / 825337491 : ℚ)) * X ^ 4 + C ((451589256132 / 275112497 : ℚ)) * X ^ 5 + C ((-759102880676 / 825337491 : ℚ)) * X ^ 6 + C ((-1286481018568 / 275112497 : ℚ)) * X ^ 7 + C ((-5651406652732 / 825337491 : ℚ)) * X ^ 8 + C ((-5599602246184 / 825337491 : ℚ)) * X ^ 9 + C ((-5359361788316 / 825337491 : ℚ)) * X ^ 10 + C ((-6912770130484 / 825337491 : ℚ)) * X ^ 11 + C ((-2822059490884 / 275112497 : ℚ)) * X ^ 12 + C ((-2978529580968 / 275112497 : ℚ)) * X ^ 13 + C ((-9672764952836 / 825337491 : ℚ)) * X ^ 14 + C ((-8505344668772 / 825337491 : ℚ)) * X ^ 15 + C ((-6178034766248 / 825337491 : ℚ)) * X ^ 16 + C ((-4431433251184 / 825337491 : ℚ)) * X ^ 17 + C ((-1639682638972 / 825337491 : ℚ)) * X ^ 18
theorem UP73_pre_eq :
    UC_0_1_re * UP73_Fre - UC_0_1_im * UP73_Fim = UP73_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP73_Fre, UP73_Fim, UP73_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP73_pim_eq :
    UC_0_1_re * UP73_Fim + UC_0_1_im * UP73_Fre = UP73_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP73_Fre, UP73_Fim, UP73_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP73_mul : UC_0_1 * UP73_F = ofLadj UP73_pre UP73_pim := by
  rw [UC_0_1, UP73_F, ofLadj_mul, UP73_pre_eq, UP73_pim_eq]

def UP74_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def UP74_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def UP74_F : Ki := ofLadj UP74_Fre UP74_Fim
def UP74_pre : Polynomial ℚ := C ((-79229933980 / 275112497 : ℚ)) + C ((-1319833106704 / 275112497 : ℚ)) * X + C ((-240908852260 / 25010227 : ℚ)) * X ^ 2 + C ((-12916626217172 / 825337491 : ℚ)) * X ^ 3 + C ((-19624458955844 / 825337491 : ℚ)) * X ^ 4 + C ((-23728270901656 / 825337491 : ℚ)) * X ^ 5 + C ((-27447560600756 / 825337491 : ℚ)) * X ^ 6 + C ((-907578561364 / 25010227 : ℚ)) * X ^ 7 + C ((-29448202154908 / 825337491 : ℚ)) * X ^ 8 + C ((-9948066501660 / 275112497 : ℚ)) * X ^ 9 + C ((-10049123347496 / 275112497 : ℚ)) * X ^ 10 + C ((-30022419161536 / 825337491 : ℚ)) * X ^ 11 + C ((-72142894552 / 2273657 : ℚ)) * X ^ 12 + C ((-7298069126800 / 275112497 : ℚ)) * X ^ 13 + C ((-16531575937736 / 825337491 : ℚ)) * X ^ 14 + C ((-3153653841344 / 275112497 : ℚ)) * X ^ 15 + C ((-1714074131184 / 275112497 : ℚ)) * X ^ 16 + C ((-1422932694452 / 825337491 : ℚ)) * X ^ 17 + C ((864672045136 / 825337491 : ℚ)) * X ^ 18
def UP74_pim : Polynomial ℚ := C ((945969606628 / 275112497 : ℚ)) + C ((1891939213256 / 275112497 : ℚ)) * X + C ((628871963180 / 75030681 : ℚ)) * X ^ 2 + C ((8620663786160 / 825337491 : ℚ)) * X ^ 3 + C ((680870575160 / 75030681 : ℚ)) * X ^ 4 + C ((4470727884092 / 825337491 : ℚ)) * X ^ 5 + C ((193448208004 / 75030681 : ℚ)) * X ^ 6 + C ((-692203007956 / 275112497 : ℚ)) * X ^ 7 + C ((-4525982590240 / 825337491 : ℚ)) * X ^ 8 + C ((-4582865797424 / 825337491 : ℚ)) * X ^ 9 + C ((-4845235096936 / 825337491 : ℚ)) * X ^ 10 + C ((-8065796316632 / 825337491 : ℚ)) * X ^ 11 + C ((-3762119178776 / 275112497 : ℚ)) * X ^ 12 + C ((-4263500263684 / 275112497 : ℚ)) * X ^ 13 + C ((-14550456189416 / 825337491 : ℚ)) * X ^ 14 + C ((-13254813085324 / 825337491 : ℚ)) * X ^ 15 + C ((-9897720382600 / 825337491 : ℚ)) * X ^ 16 + C ((-7156712783032 / 825337491 : ℚ)) * X ^ 17 + C ((-2613929211064 / 825337491 : ℚ)) * X ^ 18
theorem UP74_pre_eq :
    UC_0_1_re * UP74_Fre - UC_0_1_im * UP74_Fim = UP74_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP74_Fre, UP74_Fim, UP74_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP74_pim_eq :
    UC_0_1_re * UP74_Fim + UC_0_1_im * UP74_Fre = UP74_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP74_Fre, UP74_Fim, UP74_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP74_mul : UC_0_1 * UP74_F = ofLadj UP74_pre UP74_pim := by
  rw [UC_0_1, UP74_F, ofLadj_mul, UP74_pre_eq, UP74_pim_eq]

def UP75_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def UP75_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def UP75_F : Ki := ofLadj UP75_Fre UP75_Fim
def UP75_pre : Polynomial ℚ := C ((8469026032 / 25010227 : ℚ)) + C ((1319833106704 / 275112497 : ℚ)) * X + C ((7899111807082 / 825337491 : ℚ)) * X ^ 2 + C ((12951943629566 / 825337491 : ℚ)) * X ^ 3 + C ((6437690288728 / 275112497 : ℚ)) * X ^ 4 + C ((697215572236 / 25010227 : ℚ)) * X ^ 5 + C ((8668183062080 / 275112497 : ℚ)) * X ^ 6 + C ((27827126323664 / 825337491 : ℚ)) * X ^ 7 + C ((8838524647306 / 275112497 : ℚ)) * X ^ 8 + C ((26217327923392 / 825337491 : ℚ)) * X ^ 9 + C ((25986714100774 / 825337491 : ℚ)) * X ^ 10 + C ((8541105258080 / 275112497 : ℚ)) * X ^ 11 + C ((22027214780662 / 825337491 : ℚ)) * X ^ 12 + C ((555097458070 / 25010227 : ℚ)) * X ^ 13 + C ((13563630312352 / 825337491 : ℚ)) * X ^ 14 + C ((7479039807586 / 825337491 : ℚ)) * X ^ 15 + C ((358919741984 / 75030681 : ℚ)) * X ^ 16 + C ((951681859372 / 825337491 : ℚ)) * X ^ 17 + C ((-1035015649894 / 825337491 : ℚ)) * X ^ 18
def UP75_pim : Polynomial ℚ := C ((-898832709960 / 275112497 : ℚ)) + C ((-1797665419920 / 275112497 : ℚ)) * X + C ((-6325030128946 / 825337491 : ℚ)) * X ^ 2 + C ((-2524697994558 / 275112497 : ℚ)) * X ^ 3 + C ((-5807847266180 / 825337491 : ℚ)) * X ^ 4 + C ((-2196515892728 / 825337491 : ℚ)) * X ^ 5 + C ((746366999996 / 825337491 : ℚ)) * X ^ 6 + C ((1715792452288 / 275112497 : ℚ)) * X ^ 7 + C ((234512639254 / 25010227 : ℚ)) * X ^ 8 + C ((2565824216144 / 275112497 : ℚ)) * X ^ 9 + C ((7498526479918 / 825337491 : ℚ)) * X ^ 10 + C ((9904135286684 / 825337491 : ℚ)) * X ^ 11 + C ((4103248031150 / 275112497 : ℚ)) * X ^ 12 + C ((13042831794122 / 825337491 : ℚ)) * X ^ 13 + C ((14250451201900 / 825337491 : ℚ)) * X ^ 14 + C ((12608251088390 / 825337491 : ℚ)) * X ^ 15 + C ((3084455905768 / 275112497 : ℚ)) * X ^ 16 + C ((6612055489036 / 825337491 : ℚ)) * X ^ 17 + C ((2467493134534 / 825337491 : ℚ)) * X ^ 18
theorem UP75_pre_eq :
    UC_0_1_re * UP75_Fre - UC_0_1_im * UP75_Fim = UP75_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP75_Fre, UP75_Fim, UP75_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP75_pim_eq :
    UC_0_1_re * UP75_Fim + UC_0_1_im * UP75_Fre = UP75_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP75_Fre, UP75_Fim, UP75_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP75_mul : UC_0_1 * UP75_F = ofLadj UP75_pre UP75_pim := by
  rw [UC_0_1, UP75_F, ofLadj_mul, UP75_pre_eq, UP75_pim_eq]

def UP76_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def UP76_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def UP76_F : Ki := ofLadj UP76_Fre UP76_Fim
def UP76_pre : Polynomial ℚ := C ((780046620 / 25010227 : ℚ)) + C ((-188547586672 / 275112497 : ℚ)) * X + C ((-1217139056612 / 825337491 : ℚ)) * X ^ 2 + C ((-2079224076224 / 825337491 : ℚ)) * X ^ 3 + C ((-3307097674888 / 825337491 : ℚ)) * X ^ 4 + C ((-4277656942400 / 825337491 : ℚ)) * X ^ 5 + C ((-5035286962984 / 825337491 : ℚ)) * X ^ 6 + C ((-5264449090708 / 825337491 : ℚ)) * X ^ 7 + C ((-1585818180464 / 275112497 : ℚ)) * X ^ 8 + C ((-4400809944896 / 825337491 : ℚ)) * X ^ 9 + C ((-4126977528748 / 825337491 : ℚ)) * X ^ 10 + C ((-4052007761504 / 825337491 : ℚ)) * X ^ 11 + C ((-3561334768732 / 825337491 : ℚ)) * X ^ 12 + C ((-1061223629428 / 275112497 : ℚ)) * X ^ 13 + C ((-2678230465168 / 825337491 : ℚ)) * X ^ 14 + C ((-1778041665932 / 825337491 : ℚ)) * X ^ 15 + C ((-1000560792548 / 825337491 : ℚ)) * X ^ 16 + C ((-80976923988 / 275112497 : ℚ)) * X ^ 17 + C ((179309749888 / 825337491 : ℚ)) * X ^ 18
def UP76_pim : Polynomial ℚ := C ((202476939044 / 275112497 : ℚ)) + C ((404953878088 / 275112497 : ℚ)) * X + C ((1507841953828 / 825337491 : ℚ)) * X ^ 2 + C ((1911923773624 / 825337491 : ℚ)) * X ^ 3 + C ((1875651551120 / 825337491 : ℚ)) * X ^ 4 + C ((439235289472 / 275112497 : ℚ)) * X ^ 5 + C ((183036358400 / 275112497 : ℚ)) * X ^ 6 + C ((-510436074620 / 825337491 : ℚ)) * X ^ 7 + C ((-365782474256 / 275112497 : ℚ)) * X ^ 8 + C ((-1044933459472 / 825337491 : ℚ)) * X ^ 9 + C ((-269303729636 / 275112497 : ℚ)) * X ^ 10 + C ((-1071450508088 / 825337491 : ℚ)) * X ^ 11 + C ((-1334989827268 / 825337491 : ℚ)) * X ^ 12 + C ((-1390947876268 / 825337491 : ℚ)) * X ^ 13 + C ((-1742615732768 / 825337491 : ℚ)) * X ^ 14 + C ((-1854943597876 / 825337491 : ℚ)) * X ^ 15 + C ((-1601480903804 / 825337491 : ℚ)) * X ^ 16 + C ((-108488492884 / 75030681 : ℚ)) * X ^ 17 + C ((-146103753512 / 275112497 : ℚ)) * X ^ 18
theorem UP76_pre_eq :
    UC_0_1_re * UP76_Fre - UC_0_1_im * UP76_Fim = UP76_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP76_Fre, UP76_Fim, UP76_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP76_pim_eq :
    UC_0_1_re * UP76_Fim + UC_0_1_im * UP76_Fre = UP76_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP76_Fre, UP76_Fim, UP76_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP76_mul : UC_0_1 * UP76_F = ofLadj UP76_pre UP76_pim := by
  rw [UC_0_1, UP76_F, ofLadj_mul, UP76_pre_eq, UP76_pim_eq]

def UP77_Fre : Polynomial ℚ := C (3)
def UP77_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def UP77_F : Ki := ofLadj UP77_Fre UP77_Fim
def UP77_pre : Polynomial ℚ := C ((20894028558 / 275112497 : ℚ)) + C ((-56781201586 / 275112497 : ℚ)) * X ^ 2 + C ((-130187368422 / 275112497 : ℚ)) * X ^ 3 + C ((-197474288512 / 275112497 : ℚ)) * X ^ 4 + C ((-236946493512 / 275112497 : ℚ)) * X ^ 5 + C ((-236946493512 / 275112497 : ℚ)) * X ^ 6 + C ((-197474288512 / 275112497 : ℚ)) * X ^ 7 + C ((-130187368422 / 275112497 : ℚ)) * X ^ 8 + C ((-56781201586 / 275112497 : ℚ)) * X ^ 9
def UP77_pim : Polynomial ℚ := C ((70705345002 / 275112497 : ℚ)) + C ((141410690004 / 275112497 : ℚ)) * X + C ((190222715514 / 275112497 : ℚ)) * X ^ 2 + C ((201099219070 / 275112497 : ℚ)) * X ^ 3 + C ((170662689172 / 275112497 : ℚ)) * X ^ 4 + C ((107912582220 / 275112497 : ℚ)) * X ^ 5 + C ((33498107784 / 275112497 : ℚ)) * X ^ 6 + C ((-29251999168 / 275112497 : ℚ)) * X ^ 7 + C ((-59688529066 / 275112497 : ℚ)) * X ^ 8 + C ((-48812025510 / 275112497 : ℚ)) * X ^ 9
theorem UP77_pre_eq :
    UC_0_1_re * UP77_Fre - UC_0_1_im * UP77_Fim = UP77_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP77_Fre, UP77_Fim, UP77_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP77_pim_eq :
    UC_0_1_re * UP77_Fim + UC_0_1_im * UP77_Fre = UP77_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_0_1_re, UC_0_1_im, UP77_Fre, UP77_Fim, UP77_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP77_mul : UC_0_1 * UP77_F = ofLadj UP77_pre UP77_pim := by
  rw [UC_0_1, UP77_F, ofLadj_mul, UP77_pre_eq, UP77_pim_eq]

def UP78_Fre : Polynomial ℚ := C (-6) + C (-1) * X ^ 2 + C (-6) * X ^ 3 + C (2) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-1) * X ^ 9
def UP78_Fim : Polynomial ℚ := C (-4) + C (-8) * X + C (1) * X ^ 2 + C ((-15 / 2 : ℚ)) * X ^ 3 + C (-5) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((-17 / 2 : ℚ)) * X ^ 6 + C (-3) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C (-9) * X ^ 9
def UP78_F : Ki := ofLadj UP78_Fre UP78_Fim
def UP78_pre : Polynomial ℚ := C ((-73882471684 / 25010227 : ℚ)) + C ((-5314459632384 / 275112497 : ℚ)) * X + C ((-10127788764158 / 275112497 : ℚ)) * X ^ 2 + C ((-47694713363272 / 825337491 : ℚ)) * X ^ 3 + C ((-22512330333982 / 275112497 : ℚ)) * X ^ 4 + C ((-77968974610792 / 825337491 : ℚ)) * X ^ 5 + C ((-28268106626142 / 275112497 : ℚ)) * X ^ 6 + C ((-88581176208484 / 825337491 : ℚ)) * X ^ 7 + C ((-27330120716598 / 275112497 : ℚ)) * X ^ 8 + C ((-80730345347750 / 825337491 : ℚ)) * X ^ 9 + C ((-79808514755452 / 825337491 : ℚ)) * X ^ 10 + C ((-76990127019332 / 825337491 : ℚ)) * X ^ 11 + C ((-63865135858300 / 825337491 : ℚ)) * X ^ 12 + C ((-50346979055276 / 825337491 : ℚ)) * X ^ 13 + C ((-34295648786522 / 825337491 : ℚ)) * X ^ 14 + C ((-5192840879228 / 275112497 : ℚ)) * X ^ 15 + C ((-5831142892474 / 825337491 : ℚ)) * X ^ 16 + C ((1004202375160 / 825337491 : ℚ)) * X ^ 17 + C ((5465662568854 / 825337491 : ℚ)) * X ^ 18
def UP78_pim : Polynomial ℚ := C ((7010582525576 / 825337491 : ℚ)) + C ((14021165051152 / 825337491 : ℚ)) * X + C ((13601783976086 / 825337491 : ℚ)) * X ^ 2 + C ((1174853912473 / 75030681 : ℚ)) * X ^ 3 + C ((1146283141132 / 275112497 : ℚ)) * X ^ 4 + C ((-4090791276504 / 275112497 : ℚ)) * X ^ 5 + C ((-24191293547570 / 825337491 : ℚ)) * X ^ 6 + C ((-3545425861904 / 75030681 : ℚ)) * X ^ 7 + C ((-15877969218037 / 275112497 : ℚ)) * X ^ 8 + C ((-15812759246374 / 275112497 : ℚ)) * X ^ 9 + C ((-46628927499527 / 825337491 : ℚ)) * X ^ 10 + C ((-52433971469488 / 825337491 : ℚ)) * X ^ 11 + C ((-19413005146483 / 275112497 : ℚ)) * X ^ 12 + C ((-19003428041596 / 275112497 : ℚ)) * X ^ 13 + C ((-18712087756972 / 275112497 : ℚ)) * X ^ 14 + C ((-47194691314450 / 825337491 : ℚ)) * X ^ 15 + C ((-32510660189977 / 825337491 : ℚ)) * X ^ 16 + C ((-1988404574615 / 75030681 : ℚ)) * X ^ 17 + C ((-8091251515826 / 825337491 : ℚ)) * X ^ 18
theorem UP78_pre_eq :
    UC_2_0_re * UP78_Fre - UC_2_0_im * UP78_Fim = UP78_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP78_Fre, UP78_Fim, UP78_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP78_pim_eq :
    UC_2_0_re * UP78_Fim + UC_2_0_im * UP78_Fre = UP78_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP78_Fre, UP78_Fim, UP78_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP78_mul : UC_2_0 * UP78_F = ofLadj UP78_pre UP78_pim := by
  rw [UC_2_0, UP78_F, ofLadj_mul, UP78_pre_eq, UP78_pim_eq]

def UP79_Fre : Polynomial ℚ := C (24) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (-4) * X ^ 4 + C (15) * X ^ 5 + C (15) * X ^ 6 + C (-4) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
def UP79_Fim : Polynomial ℚ := C (10) + C (20) * X + C (-2) * X ^ 2 + C (18) * X ^ 3 + C (14) * X ^ 4 + C (-3) * X ^ 5 + C (23) * X ^ 6 + C (6) * X ^ 7 + C (2) * X ^ 8 + C (22) * X ^ 9
def UP79_F : Ki := ofLadj UP79_Fre UP79_Fim
def UP79_pre : Polynomial ℚ := C ((1257906391952 / 275112497 : ℚ)) + C ((13286149080960 / 275112497 : ℚ)) * X + C ((82430588015608 / 825337491 : ℚ)) * X ^ 2 + C ((44881023058952 / 275112497 : ℚ)) * X ^ 3 + C ((199617331429096 / 825337491 : ℚ)) * X ^ 4 + C ((238583377005178 / 825337491 : ℚ)) * X ^ 5 + C ((267606107574682 / 825337491 : ℚ)) * X ^ 6 + C ((285159101261038 / 825337491 : ℚ)) * X ^ 7 + C ((90545982068172 / 275112497 : ℚ)) * X ^ 8 + C ((266563467057176 / 825337491 : ℚ)) * X ^ 9 + C ((262615223057794 / 825337491 : ℚ)) * X ^ 10 + C ((257435042477872 / 825337491 : ℚ)) * X ^ 11 + C ((20250615983174 / 75030681 : ℚ)) * X ^ 12 + C ((184132879041568 / 825337491 : ℚ)) * X ^ 13 + C ((45664959009220 / 275112497 : ℚ)) * X ^ 14 + C ((76744648936910 / 825337491 : ℚ)) * X ^ 15 + C ((13519323491312 / 275112497 : ℚ)) * X ^ 16 + C ((3845079968144 / 275112497 : ℚ)) * X ^ 17 + C ((-8797120895032 / 825337491 : ℚ)) * X ^ 18
def UP79_pim : Polynomial ℚ := C ((-26494606943588 / 825337491 : ℚ)) + C ((-52989213887176 / 825337491 : ℚ)) * X + C ((-21279115654448 / 275112497 : ℚ)) * X ^ 2 + C ((-73405514300840 / 825337491 : ℚ)) * X ^ 3 + C ((-56053747840252 / 825337491 : ℚ)) * X ^ 4 + C ((-17993422996850 / 825337491 : ℚ)) * X ^ 5 + C ((3953367114618 / 275112497 : ℚ)) * X ^ 6 + C ((18332583493606 / 275112497 : ℚ)) * X ^ 7 + C ((80760424660676 / 825337491 : ℚ)) * X ^ 8 + C ((80057832522508 / 825337491 : ℚ)) * X ^ 9 + C ((25551959072582 / 275112497 : ℚ)) * X ^ 10 + C ((98201709698344 / 825337491 : ℚ)) * X ^ 11 + C ((119747542178942 / 825337491 : ℚ)) * X ^ 12 + C ((42397906650116 / 275112497 : ℚ)) * X ^ 13 + C ((136059295149676 / 825337491 : ℚ)) * X ^ 14 + C ((120810679201838 / 825337491 : ℚ)) * X ^ 15 + C ((87142412366116 / 825337491 : ℚ)) * X ^ 16 + C ((62405114796392 / 825337491 : ℚ)) * X ^ 17 + C ((7886507889036 / 275112497 : ℚ)) * X ^ 18
theorem UP79_pre_eq :
    UC_2_0_re * UP79_Fre - UC_2_0_im * UP79_Fim = UP79_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP79_Fre, UP79_Fim, UP79_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP79_pim_eq :
    UC_2_0_re * UP79_Fim + UC_2_0_im * UP79_Fre = UP79_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP79_Fre, UP79_Fim, UP79_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP79_mul : UC_2_0 * UP79_F = ofLadj UP79_pre UP79_pim := by
  rw [UC_2_0, UP79_F, ofLadj_mul, UP79_pre_eq, UP79_pim_eq]

def UP80_Fre : Polynomial ℚ := C (36) + C (14) * X ^ 2 + C (33) * X ^ 3 + C (-5) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (-5) * X ^ 7 + C (33) * X ^ 8 + C (14) * X ^ 9
def UP80_Fim : Polynomial ℚ := C (14) + C (28) * X + C (-6) * X ^ 2 + C (23) * X ^ 3 + C (21) * X ^ 4 + C (-6) * X ^ 5 + C (34) * X ^ 6 + C (7) * X ^ 7 + C (5) * X ^ 8 + C (34) * X ^ 9
def UP80_F : Ki := ofLadj UP80_Fre UP80_Fim
def UP80_pre : Polynomial ℚ := C ((1554705860904 / 275112497 : ℚ)) + C ((18600608713344 / 275112497 : ℚ)) * X + C ((37821086693692 / 275112497 : ℚ)) * X ^ 2 + C ((183026811997406 / 825337491 : ℚ)) * X ^ 3 + C ((92239705575146 / 275112497 : ℚ)) * X ^ 4 + C ((336571655644726 / 825337491 : ℚ)) * X ^ 5 + C ((387434396733748 / 825337491 : ℚ)) * X ^ 6 + C ((423887519394598 / 825337491 : ℚ)) * X ^ 7 + C ((416828493132752 / 825337491 : ℚ)) * X ^ 8 + C ((140763058022002 / 275112497 : ℚ)) * X ^ 9 + C ((426665084879650 / 825337491 : ℚ)) * X ^ 10 + C ((141149005647856 / 275112497 : ℚ)) * X ^ 11 + C ((370863258739618 / 825337491 : ℚ)) * X ^ 12 + C ((102941971328310 / 275112497 : ℚ)) * X ^ 13 + C ((77933893711782 / 275112497 : ℚ)) * X ^ 14 + C ((44972325757292 / 275112497 : ℚ)) * X ^ 15 + C ((72064154466836 / 825337491 : ℚ)) * X ^ 16 + C ((21201413377814 / 825337491 : ℚ)) * X ^ 17 + C ((-12251425397284 / 825337491 : ℚ)) * X ^ 18
def UP80_pim : Polynomial ℚ := C ((-39483956555596 / 825337491 : ℚ)) + C ((-78967913111192 / 825337491 : ℚ)) * X + C ((-97796490996992 / 825337491 : ℚ)) * X ^ 2 + C ((-10865631051862 / 75030681 : ℚ)) * X ^ 3 + C ((-35118172290158 / 275112497 : ℚ)) * X ^ 4 + C ((-61509947662858 / 825337491 : ℚ)) * X ^ 5 + C ((-28283344140224 / 825337491 : ℚ)) * X ^ 6 + C ((908027390318 / 25010227 : ℚ)) * X ^ 7 + C ((65453422310368 / 825337491 : ℚ)) * X ^ 8 + C ((22054090099158 / 275112497 : ℚ)) * X ^ 9 + C ((69903521729810 / 825337491 : ℚ)) * X ^ 10 + C ((114763078649240 / 825337491 : ℚ)) * X ^ 11 + C ((159622635568670 / 825337491 : ℚ)) * X ^ 12 + C ((16562951353346 / 75030681 : ℚ)) * X ^ 13 + C ((68208921149134 / 275112497 : ℚ)) * X ^ 14 + C ((188240034721184 / 825337491 : ℚ)) * X ^ 15 + C ((139531067515300 / 825337491 : ℚ)) * X ^ 16 + C ((100820468475070 / 825337491 : ℚ)) * X ^ 17 + C ((1142661286548 / 25010227 : ℚ)) * X ^ 18
theorem UP80_pre_eq :
    UC_2_0_re * UP80_Fre - UC_2_0_im * UP80_Fim = UP80_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP80_Fre, UP80_Fim, UP80_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP80_pim_eq :
    UC_2_0_re * UP80_Fim + UC_2_0_im * UP80_Fre = UP80_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP80_Fre, UP80_Fim, UP80_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP80_mul : UC_2_0 * UP80_F = ofLadj UP80_pre UP80_pim := by
  rw [UC_2_0, UP80_F, ofLadj_mul, UP80_pre_eq, UP80_pim_eq]

def UP81_Fre : Polynomial ℚ := C (-34) + C (-11) * X ^ 2 + C (-29) * X ^ 3 + C (7) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (7) * X ^ 7 + C (-29) * X ^ 8 + C (-11) * X ^ 9
def UP81_Fim : Polynomial ℚ := C (-14) + C (-28) * X + C (6) * X ^ 2 + C (-26) * X ^ 3 + C (-18) * X ^ 4 + C (4) * X ^ 5 + C (-32) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (-34) * X ^ 9
def UP81_F : Ki := ofLadj UP81_Fre UP81_Fim
def UP81_pre : Polynomial ℚ := C ((-5180025302284 / 825337491 : ℚ)) + C ((-18600608713344 / 275112497 : ℚ)) * X + C ((-112594302122054 / 825337491 : ℚ)) * X ^ 2 + C ((-16672103224982 / 75030681 : ℚ)) * X ^ 3 + C ((-8247484801260 / 25010227 : ℚ)) * X ^ 4 + C ((-326222438991380 / 825337491 : ℚ)) * X ^ 5 + C ((-122263227421466 / 275112497 : ℚ)) * X ^ 6 + C ((-393807021336814 / 825337491 : ℚ)) * X ^ 7 + C ((-375061616202476 / 825337491 : ℚ)) * X ^ 8 + C ((-123684476491910 / 275112497 : ℚ)) * X ^ 9 + C ((-367574995659688 / 825337491 : ℚ)) * X ^ 10 + C ((-120490245485556 / 275112497 : ℚ)) * X ^ 11 + C ((-311773169519656 / 825337491 : ℚ)) * X ^ 12 + C ((-258459127353676 / 825337491 : ℚ)) * X ^ 13 + C ((-191668480727674 / 825337491 : ℚ)) * X ^ 14 + C ((-35641456063460 / 275112497 : ℚ)) * X ^ 15 + C ((-55096395095974 / 825337491 : ℚ)) * X ^ 16 + C ((-4843050607652 / 275112497 : ℚ)) * X ^ 17 + C ((14715654704854 / 825337491 : ℚ)) * X ^ 18
def UP81_pim : Polynomial ℚ := C ((37491034193452 / 825337491 : ℚ)) + C ((74982068386904 / 825337491 : ℚ)) * X + C ((89424135543256 / 825337491 : ℚ)) * X ^ 2 + C ((104698498404560 / 825337491 : ℚ)) * X ^ 3 + C ((81715773918848 / 825337491 : ℚ)) * X ^ 4 + C ((29374759012124 / 825337491 : ℚ)) * X ^ 5 + C ((-1098264305308 / 75030681 : ℚ)) * X ^ 6 + C ((-73416515513980 / 825337491 : ℚ)) * X ^ 7 + C ((-110562955753664 / 825337491 : ℚ)) * X ^ 8 + C ((-110140275915968 / 825337491 : ℚ)) * X ^ 9 + C ((-35744069813368 / 275112497 : ℚ)) * X ^ 10 + C ((-140671069357112 / 825337491 : ℚ)) * X ^ 11 + C ((-174109929274120 / 825337491 : ℚ)) * X ^ 12 + C ((-185643929954608 / 825337491 : ℚ)) * X ^ 13 + C ((-200495612978216 / 825337491 : ℚ)) * X ^ 14 + C ((-5425672638044 / 25010227 : ℚ)) * X ^ 15 + C ((-43520736500476 / 275112497 : ℚ)) * X ^ 16 + C ((-93091712479628 / 825337491 : ℚ)) * X ^ 17 + C ((-11870710558912 / 275112497 : ℚ)) * X ^ 18
theorem UP81_pre_eq :
    UC_2_0_re * UP81_Fre - UC_2_0_im * UP81_Fim = UP81_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP81_Fre, UP81_Fim, UP81_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP81_pim_eq :
    UC_2_0_re * UP81_Fim + UC_2_0_im * UP81_Fre = UP81_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP81_Fre, UP81_Fim, UP81_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP81_mul : UC_2_0 * UP81_F = ofLadj UP81_pre UP81_pim := by
  rw [UC_2_0, UP81_F, ofLadj_mul, UP81_pre_eq, UP81_pim_eq]

def UP82_Fre : Polynomial ℚ := C (8) + C (2) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (6) * X ^ 8 + C (2) * X ^ 9
def UP82_Fim : Polynomial ℚ := C (2) + C (4) * X + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 6 + C (6) * X ^ 9
def UP82_F : Ki := ofLadj UP82_Fre UP82_Fim
def UP82_pre : Polynomial ℚ := C ((-70708516144 / 825337491 : ℚ)) + C ((2657229816192 / 275112497 : ℚ)) * X + C ((17417109430900 / 825337491 : ℚ)) * X ^ 2 + C ((29470415616740 / 825337491 : ℚ)) * X ^ 3 + C ((46681300321916 / 825337491 : ℚ)) * X ^ 4 + C ((20210318705836 / 275112497 : ℚ)) * X ^ 5 + C ((71026072467748 / 825337491 : ℚ)) * X ^ 6 + C ((74516612124176 / 825337491 : ℚ)) * X ^ 7 + C ((67281769012484 / 825337491 : ℚ)) * X ^ 8 + C ((62366670885224 / 825337491 : ℚ)) * X ^ 9 + C ((58410866101448 / 825337491 : ℚ)) * X ^ 10 + C ((57191079242944 / 825337491 : ℚ)) * X ^ 11 + C ((50439176652872 / 825337491 : ℚ)) * X ^ 12 + C ((44949561454324 / 825337491 : ℚ)) * X ^ 13 + C ((12603784465248 / 275112497 : ℚ)) * X ^ 14 + C ((25286749781944 / 825337491 : ℚ)) * X ^ 15 + C ((14037905839528 / 825337491 : ℚ)) * X ^ 16 + C ((1214263163096 / 275112497 : ℚ)) * X ^ 17 + C ((-2548562020316 / 825337491 : ℚ)) * X ^ 18
def UP82_pim : Polynomial ℚ := C ((-8487597168148 / 825337491 : ℚ)) + C ((-16975194336296 / 825337491 : ℚ)) * X + C ((-1942371158752 / 75030681 : ℚ)) * X ^ 2 + C ((-8862228135460 / 275112497 : ℚ)) * X ^ 3 + C ((-26415456594976 / 825337491 : ℚ)) * X ^ 4 + C ((-18256491643660 / 825337491 : ℚ)) * X ^ 5 + C ((-7569785810116 / 825337491 : ℚ)) * X ^ 6 + C ((7304406399460 / 825337491 : ℚ)) * X ^ 7 + C ((15621655840532 / 825337491 : ℚ)) * X ^ 8 + C ((4996917770532 / 275112497 : ℚ)) * X ^ 9 + C ((11612852909468 / 825337491 : ℚ)) * X ^ 10 + C ((15255912742952 / 825337491 : ℚ)) * X ^ 11 + C ((18898972576436 / 825337491 : ℚ)) * X ^ 12 + C ((19911960584284 / 825337491 : ℚ)) * X ^ 13 + C ((742474536832 / 25010227 : ℚ)) * X ^ 14 + C ((26322095543752 / 825337491 : ℚ)) * X ^ 15 + C ((22560052319524 / 825337491 : ℚ)) * X ^ 16 + C ((5600952094620 / 275112497 : ℚ)) * X ^ 17 + C ((6325585801372 / 825337491 : ℚ)) * X ^ 18
theorem UP82_pre_eq :
    UC_2_0_re * UP82_Fre - UC_2_0_im * UP82_Fim = UP82_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP82_Fre, UP82_Fim, UP82_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP82_pim_eq :
    UC_2_0_re * UP82_Fim + UC_2_0_im * UP82_Fre = UP82_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP82_Fre, UP82_Fim, UP82_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP82_mul : UC_2_0 * UP82_F = ofLadj UP82_pre UP82_pim := by
  rw [UC_2_0, UP82_F, ofLadj_mul, UP82_pre_eq, UP82_pim_eq]

def UP83_Fre : Polynomial ℚ := C (3)
def UP83_Fim : Polynomial ℚ := (0 : Polynomial ℚ)
def UP83_F : Ki := ofLadj UP83_Fre UP83_Fim
def UP83_pre : Polynomial ℚ := C ((-257953859786 / 275112497 : ℚ)) + C ((821409769190 / 275112497 : ℚ)) * X ^ 2 + C ((1827437752482 / 275112497 : ℚ)) * X ^ 3 + C ((2796590119538 / 275112497 : ℚ)) * X ^ 4 + C ((3350846449888 / 275112497 : ℚ)) * X ^ 5 + C ((3350846449888 / 275112497 : ℚ)) * X ^ 6 + C ((2796590119538 / 275112497 : ℚ)) * X ^ 7 + C ((1827437752482 / 275112497 : ℚ)) * X ^ 8 + C ((821409769190 / 275112497 : ℚ)) * X ^ 9
def UP83_pim : Polynomial ℚ := C ((-996461181072 / 275112497 : ℚ)) + C ((-1992922362144 / 275112497 : ℚ)) * X + C ((-2691485955260 / 275112497 : ℚ)) * X ^ 2 + C ((-2816346467280 / 275112497 : ℚ)) * X ^ 3 + C ((-2412905847884 / 275112497 : ℚ)) * X ^ 4 + C ((-1500097195640 / 275112497 : ℚ)) * X ^ 5 + C ((-44802287864 / 25010227 : ℚ)) * X ^ 6 + C ((419983485740 / 275112497 : ℚ)) * X ^ 7 + C ((823424105136 / 275112497 : ℚ)) * X ^ 8 + C ((698563593116 / 275112497 : ℚ)) * X ^ 9
theorem UP83_pre_eq :
    UC_2_0_re * UP83_Fre - UC_2_0_im * UP83_Fim = UP83_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP83_Fre, UP83_Fim, UP83_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP83_pim_eq :
    UC_2_0_re * UP83_Fim + UC_2_0_im * UP83_Fre = UP83_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [UC_2_0_re, UC_2_0_im, UP83_Fre, UP83_Fim, UP83_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem UP83_mul : UC_2_0 * UP83_F = ofLadj UP83_pre UP83_pim := by
  rw [UC_2_0, UP83_F, ofLadj_mul, UP83_pre_eq, UP83_pim_eq]

end V14Formalization.D12SigmaPlusSegreCore
