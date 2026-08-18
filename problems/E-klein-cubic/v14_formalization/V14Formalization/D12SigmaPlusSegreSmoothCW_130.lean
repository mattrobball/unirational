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

def CW_130_0_pre : Polynomial ℚ := C ((-1191732979423 / 17279915862 : ℚ)) + C ((1316747884730 / 2879985977 : ℚ)) * X + C ((6170965748125 / 8639957931 : ℚ)) * X ^ 2 + C ((12029914364902 / 8639957931 : ℚ)) * X ^ 3 + C ((6702860819891 / 2879985977 : ℚ)) * X ^ 4 + C ((49760670538585 / 17279915862 : ℚ)) * X ^ 5 + C ((63924584878387 / 17279915862 : ℚ)) * X ^ 6 + C ((35561208519229 / 8639957931 : ℚ)) * X ^ 7 + C ((72717633539773 / 17279915862 : ℚ)) * X ^ 8 + C ((24839167103255 / 5759971954 : ℚ)) * X ^ 9 + C ((77525038233857 / 17279915862 : ℚ)) * X ^ 10 + C ((39069640453850 / 8639957931 : ℚ)) * X ^ 11 + C ((69624550925477 / 17279915862 : ℚ)) * X ^ 12 + C ((62175569813515 / 17279915862 : ℚ)) * X ^ 13 + C ((48657804809969 / 17279915862 : ℚ)) * X ^ 14 + C ((14647530171247 / 8639957931 : ℚ)) * X ^ 15 + C ((3119431615863 / 2879985977 : ℚ)) * X ^ 16 + C ((758779225896 / 2879985977 : ℚ)) * X ^ 17 + C ((-268365296103 / 2879985977 : ℚ)) * X ^ 18
def CW_130_0_pim : Polynomial ℚ := C ((-7646842096393 / 17279915862 : ℚ)) + C ((-7646842096393 / 8639957931 : ℚ)) * X + C ((-3192329149668 / 2879985977 : ℚ)) * X ^ 2 + C ((-5011460680367 / 2879985977 : ℚ)) * X ^ 3 + C ((-14121806683984 / 8639957931 : ℚ)) * X ^ 4 + C ((-27899069230913 / 17279915862 : ℚ)) * X ^ 5 + C ((-24195823287155 / 17279915862 : ℚ)) * X ^ 6 + C ((-7427675274700 / 8639957931 : ℚ)) * X ^ 7 + C ((-9281394922111 / 17279915862 : ℚ)) * X ^ 8 + C ((-291592073703 / 523633814 : ℚ)) * X ^ 9 + C ((-2423060617947 / 5759971954 : ℚ)) * X ^ 10 + C ((1329403740527 / 8639957931 : ℚ)) * X ^ 11 + C ((12586796815949 / 17279915862 : ℚ)) * X ^ 12 + C ((6266814699843 / 5759971954 : ℚ)) * X ^ 13 + C ((29374089773635 / 17279915862 : ℚ)) * X ^ 14 + C ((13724904877474 / 8639957931 : ℚ)) * X ^ 15 + C ((3940109778399 / 2879985977 : ℚ)) * X ^ 16 + C ((9239082308498 / 8639957931 : ℚ)) * X ^ 17 + C ((2836542465871 / 8639957931 : ℚ)) * X ^ 18
theorem CW_130_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_020 - CW_0_im_110 * Fplus_dU_im_020 = CW_130_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_020, Fplus_dU_im_020, CW_130_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_020 + CW_0_im_110 * Fplus_dU_re_020 = CW_130_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_020, Fplus_dU_im_020, CW_130_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_0_mul :
    CW_0_c_110 * Fplus_dU_c_020 = ofLadj CW_130_0_pre CW_130_0_pim := by
  rw [CW_0_c_110, Fplus_dU_c_020, ofLadj_mul, CW_130_0_pre_eq, CW_130_0_pim_eq]

def CW_130_1_pre : Polynomial ℚ := C ((2103299525618 / 8639957931 : ℚ)) + C ((-2951723246288 / 8639957931 : ℚ)) * X + C ((-2420164046572 / 8639957931 : ℚ)) * X ^ 2 + C ((-5958947316272 / 8639957931 : ℚ)) * X ^ 3 + C ((-13454127330232 / 8639957931 : ℚ)) * X ^ 4 + C ((-14088119253922 / 8639957931 : ℚ)) * X ^ 5 + C ((-20736623053720 / 8639957931 : ℚ)) * X ^ 6 + C ((-20541004143536 / 8639957931 : ℚ)) * X ^ 7 + C ((-17823202650994 / 8639957931 : ℚ)) * X ^ 8 + C ((-1646255160274 / 785450721 : ℚ)) * X ^ 9 + C ((-5170510621196 / 2879985977 : ℚ)) * X ^ 10 + C ((-19138038300484 / 8639957931 : ℚ)) * X ^ 11 + C ((-12559808617300 / 8639957931 : ℚ)) * X ^ 12 + C ((-15688642716442 / 8639957931 : ℚ)) * X ^ 13 + C ((-11864255334722 / 8639957931 : ℚ)) * X ^ 14 + C ((-6470607075094 / 8639957931 : ℚ)) * X ^ 15 + C ((-1982751165794 / 2879985977 : ℚ)) * X ^ 16 + C ((233416767472 / 2879985977 : ℚ)) * X ^ 17 + C ((205423246070 / 2879985977 : ℚ)) * X ^ 18
def CW_130_1_pim : Polynomial ℚ := C ((1131512645614 / 2879985977 : ℚ)) + C ((2263025291228 / 2879985977 : ℚ)) * X + C ((6131380079608 / 8639957931 : ℚ)) * X ^ 2 + C ((4187141585324 / 2879985977 : ℚ)) * X ^ 3 + C ((10111289277304 / 8639957931 : ℚ)) * X ^ 4 + C ((3093202911454 / 2879985977 : ℚ)) * X ^ 5 + C ((8191495004272 / 8639957931 : ℚ)) * X ^ 6 + C ((699025656020 / 8639957931 : ℚ)) * X ^ 7 + C ((578883771910 / 2879985977 : ℚ)) * X ^ 8 + C ((222326822866 / 2879985977 : ℚ)) * X ^ 9 + C ((744580287212 / 2879985977 : ℚ)) * X ^ 10 + C ((-318983061676 / 8639957931 : ℚ)) * X ^ 11 + C ((-2871706984988 / 8639957931 : ℚ)) * X ^ 12 + C ((-215750265958 / 2879985977 : ℚ)) * X ^ 13 + C ((-8146966321370 / 8639957931 : ℚ)) * X ^ 14 + C ((-4592235732182 / 8639957931 : ℚ)) * X ^ 15 + C ((-6552529184978 / 8639957931 : ℚ)) * X ^ 16 + C ((-4767464803324 / 8639957931 : ℚ)) * X ^ 17 + C ((-22323150270 / 2879985977 : ℚ)) * X ^ 18
theorem CW_130_1_pre_eq :
    CW_0_re_020 * Fplus_dU_re_110 - CW_0_im_020 * Fplus_dU_im_110 = CW_130_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020, CW_0_im_020, Fplus_dU_re_110, Fplus_dU_im_110, CW_130_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_1_pim_eq :
    CW_0_re_020 * Fplus_dU_im_110 + CW_0_im_020 * Fplus_dU_re_110 = CW_130_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020, CW_0_im_020, Fplus_dU_re_110, Fplus_dU_im_110, CW_130_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_1_mul :
    CW_0_c_020 * Fplus_dU_c_110 = ofLadj CW_130_1_pre CW_130_1_pim := by
  rw [CW_0_c_020, Fplus_dU_c_110, ofLadj_mul, CW_130_1_pre_eq, CW_130_1_pim_eq]

def CW_130_2_pre : Polynomial ℚ := C ((38246516079 / 5759971954 : ℚ)) + C ((-763821719622 / 2879985977 : ℚ)) * X + C ((-1186810916340 / 2879985977 : ℚ)) * X ^ 2 + C ((-2015268141960 / 2879985977 : ℚ)) * X ^ 3 + C ((-26250886945 / 23801537 : ℚ)) * X ^ 4 + C ((-3333260311818 / 2879985977 : ℚ)) * X ^ 5 + C ((-4103989574337 / 2879985977 : ℚ)) * X ^ 6 + C ((-4582128290650 / 2879985977 : ℚ)) * X ^ 7 + C ((-4699510435043 / 2879985977 : ℚ)) * X ^ 8 + C ((-5090276051480 / 2879985977 : ℚ)) * X ^ 9 + C ((-10732772205583 / 5759971954 : ℚ)) * X ^ 10 + C ((-5485998667423 / 2879985977 : ℚ)) * X ^ 11 + C ((-836829887849 / 523633814 : ℚ)) * X ^ 12 + C ((-3903465135140 / 2879985977 : ℚ)) * X ^ 13 + C ((-2684242293083 / 2879985977 : ℚ)) * X ^ 14 + C ((-106143730604 / 261816907 : ℚ)) * X ^ 15 + C ((-73793934872 / 261816907 : ℚ)) * X ^ 16 + C ((-41004021073 / 2879985977 : ℚ)) * X ^ 17 + C ((238189933661 / 2879985977 : ℚ)) * X ^ 18
def CW_130_2_pim : Polynomial ℚ := C ((973900407567 / 5759971954 : ℚ)) + C ((973900407567 / 2879985977 : ℚ)) * X + C ((971720170915 / 2879985977 : ℚ)) * X ^ 2 + C ((1524300655160 / 2879985977 : ℚ)) * X ^ 3 + C ((970979917826 / 2879985977 : ℚ)) * X ^ 4 + C ((597896197852 / 2879985977 : ℚ)) * X ^ 5 + C ((547008089894 / 2879985977 : ℚ)) * X ^ 6 + C ((-98585083016 / 2879985977 : ℚ)) * X ^ 7 + C ((-367427671153 / 2879985977 : ℚ)) * X ^ 8 + C ((-435430899179 / 2879985977 : ℚ)) * X ^ 9 + C ((-1410329337473 / 5759971954 : ℚ)) * X ^ 10 + C ((-1542543652153 / 2879985977 : ℚ)) * X ^ 11 + C ((-4759845271139 / 5759971954 : ℚ)) * X ^ 12 + C ((-2647476168475 / 2879985977 : ℚ)) * X ^ 13 + C ((-3268059880746 / 2879985977 : ℚ)) * X ^ 14 + C ((-2536075849522 / 2879985977 : ℚ)) * X ^ 15 + C ((-1839086102556 / 2879985977 : ℚ)) * X ^ 16 + C ((-1417005081929 / 2879985977 : ℚ)) * X ^ 17 + C ((-447505882027 / 2879985977 : ℚ)) * X ^ 18
theorem CW_130_2_pre_eq :
    CW_1_re_110 * Fplus_dV_re_020 - CW_1_im_110 * Fplus_dV_im_020 = CW_130_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_020, Fplus_dV_im_020, CW_130_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_2_pim_eq :
    CW_1_re_110 * Fplus_dV_im_020 + CW_1_im_110 * Fplus_dV_re_020 = CW_130_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_020, Fplus_dV_im_020, CW_130_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_2_mul :
    CW_1_c_110 * Fplus_dV_c_020 = ofLadj CW_130_2_pre CW_130_2_pim := by
  rw [CW_1_c_110, Fplus_dV_c_020, ofLadj_mul, CW_130_2_pre_eq, CW_130_2_pim_eq]

def CW_130_3_pre : Polynomial ℚ := C ((594066840450 / 2879985977 : ℚ)) + C ((-2386452635920 / 8639957931 : ℚ)) * X + C ((-1292823476306 / 8639957931 : ℚ)) * X ^ 2 + C ((-6224371917754 / 8639957931 : ℚ)) * X ^ 3 + C ((-11159602598948 / 8639957931 : ℚ)) * X ^ 4 + C ((-3803821129620 / 2879985977 : ℚ)) * X ^ 5 + C ((-6243544825794 / 2879985977 : ℚ)) * X ^ 6 + C ((-18647967314498 / 8639957931 : ℚ)) * X ^ 7 + C ((-19169003749568 / 8639957931 : ℚ)) * X ^ 8 + C ((-6302681789828 / 2879985977 : ℚ)) * X ^ 9 + C ((-20942212022786 / 8639957931 : ℚ)) * X ^ 10 + C ((-21181958210860 / 8639957931 : ℚ)) * X ^ 11 + C ((-18555759386866 / 8639957931 : ℚ)) * X ^ 12 + C ((-17615221893178 / 8639957931 : ℚ)) * X ^ 13 + C ((-12944631831814 / 8639957931 : ℚ)) * X ^ 14 + C ((-6254317167554 / 8639957931 : ℚ)) * X ^ 15 + C ((-6174843573218 / 8639957931 : ℚ)) * X ^ 16 + C ((1144327515304 / 8639957931 : ℚ)) * X ^ 17 + C ((1234047547996 / 8639957931 : ℚ)) * X ^ 18
def CW_130_3_pim : Polynomial ℚ := C ((2728135822982 / 8639957931 : ℚ)) + C ((5456271645964 / 8639957931 : ℚ)) * X + C ((1855344950442 / 2879985977 : ℚ)) * X ^ 2 + C ((11977124655050 / 8639957931 : ℚ)) * X ^ 3 + C ((2614584859636 / 2879985977 : ℚ)) * X ^ 4 + C ((10810055894320 / 8639957931 : ℚ)) * X ^ 5 + C ((9071842006750 / 8639957931 : ℚ)) * X ^ 6 + C ((5421643591126 / 8639957931 : ℚ)) * X ^ 7 + C ((1480555823600 / 2879985977 : ℚ)) * X ^ 8 + C ((5294413618328 / 8639957931 : ℚ)) * X ^ 9 + C ((3822749045050 / 8639957931 : ℚ)) * X ^ 10 + C ((698985143324 / 8639957931 : ℚ)) * X ^ 11 + C ((-73478144194 / 261816907 : ℚ)) * X ^ 12 + C ((-1335402179014 / 2879985977 : ℚ)) * X ^ 13 + C ((-3188183397746 / 2879985977 : ℚ)) * X ^ 14 + C ((-189574992182 / 261816907 : ℚ)) * X ^ 15 + C ((-6872800540894 / 8639957931 : ℚ)) * X ^ 16 + C ((-6154855427564 / 8639957931 : ℚ)) * X ^ 17 + C ((-155181495416 / 8639957931 : ℚ)) * X ^ 18
theorem CW_130_3_pre_eq :
    CW_1_re_020 * Fplus_dV_re_110 - CW_1_im_020 * Fplus_dV_im_110 = CW_130_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020, CW_1_im_020, Fplus_dV_re_110, Fplus_dV_im_110, CW_130_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_3_pim_eq :
    CW_1_re_020 * Fplus_dV_im_110 + CW_1_im_020 * Fplus_dV_re_110 = CW_130_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020, CW_1_im_020, Fplus_dV_re_110, Fplus_dV_im_110, CW_130_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_3_mul :
    CW_1_c_020 * Fplus_dV_c_110 = ofLadj CW_130_3_pre CW_130_3_pim := by
  rw [CW_1_c_020, Fplus_dV_c_110, ofLadj_mul, CW_130_3_pre_eq, CW_130_3_pim_eq]

def CW_130_4_pre : Polynomial ℚ := C ((9413577590 / 32359393 : ℚ)) + C ((4455006416 / 32359393 : ℚ)) * X + C ((19169389663 / 32359393 : ℚ)) * X ^ 2 + C ((72750130055 / 97078179 : ℚ)) * X ^ 3 + C ((82887186892 / 97078179 : ℚ)) * X ^ 4 + C ((140753366122 / 97078179 : ℚ)) * X ^ 5 + C ((227030485915 / 194156358 : ℚ)) * X ^ 6 + C ((4470059193 / 2941763 : ℚ)) * X ^ 7 + C ((283565343235 / 194156358 : ℚ)) * X ^ 8 + C ((288096826481 / 194156358 : ℚ)) * X ^ 9 + C ((4201491469 / 2941763 : ℚ)) * X ^ 10 + C ((115984691701 / 97078179 : ℚ)) * X ^ 11 + C ((41761399743 / 32359393 : ℚ)) * X ^ 12 + C ((173080488503 / 194156358 : ℚ)) * X ^ 13 + C ((46021694375 / 64718786 : ℚ)) * X ^ 14 + C ((20981165198 / 32359393 : ℚ)) * X ^ 15 + C ((7032992795 / 194156358 : ℚ)) * X ^ 16 + C ((10251539854 / 32359393 : ℚ)) * X ^ 17 + C ((-1681270883 / 97078179 : ℚ)) * X ^ 18
def CW_130_4_pim : Polynomial ℚ := C ((64795462 / 2941763 : ℚ)) + C ((129590924 / 2941763 : ℚ)) * X + C ((-22582382804 / 97078179 : ℚ)) * X ^ 2 + C ((23025610000 / 97078179 : ℚ)) * X ^ 3 + C ((-13558142627 / 97078179 : ℚ)) * X ^ 4 + C ((33060156920 / 97078179 : ℚ)) * X ^ 5 + C ((34165241903 / 64718786 : ℚ)) * X ^ 6 + C ((57610592137 / 97078179 : ℚ)) * X ^ 7 + C ((166723795069 / 194156358 : ℚ)) * X ^ 8 + C ((15772299275 / 17650578 : ℚ)) * X ^ 9 + C ((83974679798 / 97078179 : ℚ)) * X ^ 10 + C ((81358730524 / 97078179 : ℚ)) * X ^ 11 + C ((26247593750 / 32359393 : ℚ)) * X ^ 12 + C ((205657396663 / 194156358 : ℚ)) * X ^ 13 + C ((121212908011 / 194156358 : ℚ)) * X ^ 14 + C ((31004111455 / 32359393 : ℚ)) * X ^ 15 + C ((105029931575 / 194156358 : ℚ)) * X ^ 16 + C ((2742815998 / 8825289 : ℚ)) * X ^ 17 + C ((9976392555 / 32359393 : ℚ)) * X ^ 18
theorem CW_130_4_pre_eq :
    CW_2_re_110 * Fplus_dW_re_020 - CW_2_im_110 * Fplus_dW_im_020 = CW_130_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_020, Fplus_dW_im_020, CW_130_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_4_pim_eq :
    CW_2_re_110 * Fplus_dW_im_020 + CW_2_im_110 * Fplus_dW_re_020 = CW_130_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_020, Fplus_dW_im_020, CW_130_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_4_mul :
    CW_2_c_110 * Fplus_dW_c_020 = ofLadj CW_130_4_pre CW_130_4_pim := by
  rw [CW_2_c_110, Fplus_dW_c_020, ofLadj_mul, CW_130_4_pre_eq, CW_130_4_pim_eq]

def CW_130_5_pre : Polynomial ℚ := C ((6974844466576 / 8639957931 : ℚ)) + C ((145504917760 / 8639957931 : ℚ)) * X + C ((11210666901392 / 8639957931 : ℚ)) * X ^ 2 + C ((5259933169184 / 2879985977 : ℚ)) * X ^ 3 + C ((5054756132196 / 2879985977 : ℚ)) * X ^ 4 + C ((27119973669298 / 8639957931 : ℚ)) * X ^ 5 + C ((674185353342 / 261816907 : ℚ)) * X ^ 6 + C ((9866014213404 / 2879985977 : ℚ)) * X ^ 7 + C ((26574242865998 / 8639957931 : ℚ)) * X ^ 8 + C ((26669600557802 / 8639957931 : ℚ)) * X ^ 9 + C ((8637194112506 / 2879985977 : ℚ)) * X ^ 10 + C ((19011421188044 / 8639957931 : ℚ)) * X ^ 11 + C ((25766077419758 / 8639957931 : ℚ)) * X ^ 12 + C ((5152977885470 / 2879985977 : ℚ)) * X ^ 13 + C ((981313032586 / 785450721 : ℚ)) * X ^ 14 + C ((11932137178184 / 8639957931 : ℚ)) * X ^ 15 + C ((320018653348 / 8639957931 : ℚ)) * X ^ 16 + C ((5191875662360 / 8639957931 : ℚ)) * X ^ 17 + C ((-2501637065440 / 8639957931 : ℚ)) * X ^ 18
def CW_130_5_pim : Polynomial ℚ := C ((2803725481484 / 8639957931 : ℚ)) + C ((5607450962968 / 8639957931 : ℚ)) * X + C ((-3163285136324 / 8639957931 : ℚ)) * X ^ 2 + C ((980483906104 / 785450721 : ℚ)) * X ^ 3 + C ((1571775416616 / 2879985977 : ℚ)) * X ^ 4 + C ((13764695035582 / 8639957931 : ℚ)) * X ^ 5 + C ((18371365475998 / 8639957931 : ℚ)) * X ^ 6 + C ((638113791816 / 261816907 : ℚ)) * X ^ 7 + C ((28377758980610 / 8639957931 : ℚ)) * X ^ 8 + C ((28667933504794 / 8639957931 : ℚ)) * X ^ 9 + C ((28452154697618 / 8639957931 : ℚ)) * X ^ 10 + C ((8385157071496 / 2879985977 : ℚ)) * X ^ 11 + C ((21858787731358 / 8639957931 : ℚ)) * X ^ 12 + C ((30413745023474 / 8639957931 : ℚ)) * X ^ 13 + C ((507736710430 / 261816907 : ℚ)) * X ^ 14 + C ((7476971026080 / 2879985977 : ℚ)) * X ^ 15 + C ((4679955102736 / 2879985977 : ℚ)) * X ^ 16 + C ((885678870196 / 785450721 : ℚ)) * X ^ 17 + C ((7714398933928 / 8639957931 : ℚ)) * X ^ 18
theorem CW_130_5_pre_eq :
    CW_2_re_020 * Fplus_dW_re_110 - CW_2_im_020 * Fplus_dW_im_110 = CW_130_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020, CW_2_im_020, Fplus_dW_re_110, Fplus_dW_im_110, CW_130_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_5_pim_eq :
    CW_2_re_020 * Fplus_dW_im_110 + CW_2_im_020 * Fplus_dW_re_110 = CW_130_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020, CW_2_im_020, Fplus_dW_re_110, Fplus_dW_im_110, CW_130_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_130_5_mul :
    CW_2_c_020 * Fplus_dW_c_110 = ofLadj CW_130_5_pre CW_130_5_pim := by
  rw [CW_2_c_020, Fplus_dW_c_110, ofLadj_mul, CW_130_5_pre_eq, CW_130_5_pim_eq]

@[expose] public def CW_coeff_130 : Ki := CW_0_c_110 * Fplus_dU_c_020 + CW_0_c_020 * Fplus_dU_c_110 + CW_1_c_110 * Fplus_dV_c_020 + CW_1_c_020 * Fplus_dV_c_110 + CW_2_c_110 * Fplus_dW_c_020 + CW_2_c_020 * Fplus_dW_c_110

theorem CW_coeff_130_sum :
    CW_coeff_130 = ofLadj (CW_130_0_pre + CW_130_1_pre + CW_130_2_pre + CW_130_3_pre + CW_130_4_pre + CW_130_5_pre) (CW_130_0_pim + CW_130_1_pim + CW_130_2_pim + CW_130_3_pim + CW_130_4_pim + CW_130_5_pim) := by
  simp only [CW_coeff_130, CW_130_0_mul, CW_130_1_mul, CW_130_2_mul, CW_130_3_mul, CW_130_4_mul, CW_130_5_mul]
  simpa [add_assoc] using ofLadj_add6 CW_130_0_pre CW_130_0_pim CW_130_1_pre CW_130_1_pim CW_130_2_pre CW_130_2_pim CW_130_3_pre CW_130_3_pim CW_130_4_pre CW_130_4_pim CW_130_5_pre CW_130_5_pim

def CW_130_qre : Polynomial ℚ := C ((12835273014481 / 8639957931 : ℚ)) + C ((-5059892923511 / 2879985977 : ℚ)) * X + C ((17570845173692 / 8639957931 : ℚ)) * X ^ 2 + C ((828912369803 / 8639957931 : ℚ)) * X ^ 3 + C ((-2516114396003 / 2879985977 : ℚ)) * X ^ 4 + C ((41041972691557 / 17279915862 : ℚ)) * X ^ 5 + C ((-32987910953257 / 17279915862 : ℚ)) * X ^ 6 + C ((12818419210714 / 8639957931 : ℚ)) * X ^ 7 + C ((-891478975147 / 8639957931 : ℚ)) * X ^ 8
def CW_130_qim : Polynomial ℚ := C ((6754133076356 / 8639957931 : ℚ)) + C ((6754133076356 / 8639957931 : ℚ)) * X + C ((-4548598454639 / 2879985977 : ℚ)) * X ^ 2 + C ((27049200803750 / 8639957931 : ℚ)) * X ^ 3 + C ((-16656843110794 / 8639957931 : ℚ)) * X ^ 4 + C ((9590692750995 / 5759971954 : ℚ)) * X ^ 5 + C ((3398671532621 / 5759971954 : ℚ)) * X ^ 6 + C ((-5156538353656 / 8639957931 : ℚ)) * X ^ 7 + C ((3883323206559 / 2879985977 : ℚ)) * X ^ 8
theorem CW_coeff_130_poly_re :
    CW_130_0_pre + CW_130_1_pre + CW_130_2_pre + CW_130_3_pre + CW_130_4_pre + CW_130_5_pre = (0 : Polynomial ℚ) + Phi11 * CW_130_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_130_0_pre, CW_130_1_pre, CW_130_2_pre, CW_130_3_pre, CW_130_4_pre, CW_130_5_pre, CW_130_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_130_poly_im :
    CW_130_0_pim + CW_130_1_pim + CW_130_2_pim + CW_130_3_pim + CW_130_4_pim + CW_130_5_pim = (0 : Polynomial ℚ) + Phi11 * CW_130_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_130_0_pim, CW_130_1_pim, CW_130_2_pim, CW_130_3_pim, CW_130_4_pim, CW_130_5_pim, CW_130_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_130_eq :
    CW_coeff_130 = (0 : Ki) := by
  rw [CW_coeff_130_sum, CW_coeff_130_poly_re,
    CW_coeff_130_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
