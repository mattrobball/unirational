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

def CV_201_0_pre : Polynomial ℚ := C ((-890497423652 / 8639957931 : ℚ)) + C ((-7659677155808 / 8639957931 : ℚ)) * X + C ((-14104537730336 / 8639957931 : ℚ)) * X ^ 2 + C ((-2012936413819 / 785450721 : ℚ)) * X ^ 3 + C ((-32001256441870 / 8639957931 : ℚ)) * X ^ 4 + C ((-36402625534307 / 8639957931 : ℚ)) * X ^ 5 + C ((-40071734862068 / 8639957931 : ℚ)) * X ^ 6 + C ((-41381979993811 / 8639957931 : ℚ)) * X ^ 7 + C ((-38395716005320 / 8639957931 : ℚ)) * X ^ 8 + C ((-37836255839036 / 8639957931 : ℚ)) * X ^ 9 + C ((-12454886970324 / 2879985977 : ℚ)) * X ^ 10 + C ((-36359851789682 / 8639957931 : ℚ)) * X ^ 11 + C ((-29704983755164 / 8639957931 : ℚ)) * X ^ 12 + C ((-7910572702900 / 2879985977 : ℚ)) * X ^ 13 + C ((-16253415453311 / 8639957931 : ℚ)) * X ^ 14 + C ((-211111433611 / 261816907 : ℚ)) * X ^ 15 + C ((-2871580180877 / 8639957931 : ℚ)) * X ^ 16 + C ((797529146884 / 8639957931 : ℚ)) * X ^ 17 + C ((804682080926 / 2879985977 : ℚ)) * X ^ 18
def CV_201_0_pim : Polynomial ℚ := C ((1185108947876 / 2879985977 : ℚ)) + C ((2370217895752 / 2879985977 : ℚ)) * X + C ((6528539344856 / 8639957931 : ℚ)) * X ^ 2 + C ((2376659183551 / 2879985977 : ℚ)) * X ^ 3 + C ((206464775240 / 785450721 : ℚ)) * X ^ 4 + C ((-445820479312 / 785450721 : ℚ)) * X ^ 5 + C ((-10402874220041 / 8639957931 : ℚ)) * X ^ 6 + C ((-17479134097793 / 8639957931 : ℚ)) * X ^ 7 + C ((-21097352079695 / 8639957931 : ℚ)) * X ^ 8 + C ((-20997746485367 / 8639957931 : ℚ)) * X ^ 9 + C ((-20601314791748 / 8639957931 : ℚ)) * X ^ 10 + C ((-23602921058788 / 8639957931 : ℚ)) * X ^ 11 + C ((-8868175775276 / 2879985977 : ℚ)) * X ^ 12 + C ((-25625981289809 / 8639957931 : ℚ)) * X ^ 13 + C ((-8709271300426 / 2879985977 : ℚ)) * X ^ 14 + C ((-7173499907283 / 2879985977 : ℚ)) * X ^ 15 + C ((-4948480901828 / 2879985977 : ℚ)) * X ^ 16 + C ((-903895112033 / 785450721 : ℚ)) * X ^ 17 + C ((-27823695358 / 71404611 : ℚ)) * X ^ 18
theorem CV_201_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_101 - CV_0_im_100 * Fplus_dU_im_101 = CV_201_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100, CV_0_im_100, Fplus_dU_re_101, Fplus_dU_im_101, CV_201_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_101 + CV_0_im_100 * Fplus_dU_re_101 = CV_201_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100, CV_0_im_100, Fplus_dU_re_101, Fplus_dU_im_101, CV_201_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_0_mul :
    CV_0_c_100 * Fplus_dU_c_101 = ofLadj CV_201_0_pre CV_201_0_pim := by
  rw [CV_0_c_100, Fplus_dU_c_101, ofLadj_mul, CV_201_0_pre_eq, CV_201_0_pim_eq]

def CV_201_1_pre : Polynomial ℚ := C ((-21796034665773 / 2879985977 : ℚ)) + C ((3516626563697 / 523633814 : ℚ)) * X ^ 2 + C ((55248861585228 / 2879985977 : ℚ)) * X ^ 3 + C ((30872405461631 / 523633814 : ℚ)) * X ^ 4 + C ((570078664377527 / 5759971954 : ℚ)) * X ^ 5 + C ((807254104901815 / 5759971954 : ℚ)) * X ^ 6 + C ((90916242795861 / 523633814 : ℚ)) * X ^ 7 + C ((1072990524480553 / 5759971954 : ℚ)) * X ^ 8 + C ((552134634436058 / 2879985977 : ℚ)) * X ^ 9 + C ((563956568949563 / 2879985977 : ℚ)) * X ^ 10 + C ((590273679325566 / 2879985977 : ℚ)) * X ^ 11 + C ((563956568949563 / 2879985977 : ℚ)) * X ^ 12 + C ((1065586376671449 / 5759971954 : ℚ)) * X ^ 13 + C ((962492801310097 / 5759971954 : ℚ)) * X ^ 14 + C ((704872417706151 / 5759971954 : ℚ)) * X ^ 15 + C ((457356920796239 / 5759971954 : ℚ)) * X ^ 16 + C ((20016498206541 / 523633814 : ℚ)) * X ^ 17 + C ((44390207029621 / 5759971954 : ℚ)) * X ^ 18
def CV_201_1_pim : Polynomial ℚ := C ((-74407181769780 / 2879985977 : ℚ)) + C ((-148814363539560 / 2879985977 : ℚ)) * X + C ((-483835111109217 / 5759971954 : ℚ)) * X ^ 2 + C ((-368265898391618 / 2879985977 : ℚ)) * X ^ 3 + C ((-892482729305273 / 5759971954 : ℚ)) * X ^ 4 + C ((-3997338507594 / 23801537 : ℚ)) * X ^ 5 + C ((-987035986999193 / 5759971954 : ℚ)) * X ^ 6 + C ((-421768283692122 / 2879985977 : ℚ)) * X ^ 7 + C ((-749668128817079 / 5759971954 : ℚ)) * X ^ 8 + C ((-745328407311275 / 5759971954 : ℚ)) * X ^ 9 + C ((-362322445459113 / 2879985977 : ℚ)) * X ^ 10 + C ((-24802393923260 / 261816907 : ℚ)) * X ^ 11 + C ((-183330220852607 / 2879985977 : ℚ)) * X ^ 12 + C ((-79885270641034 / 2879985977 : ℚ)) * X ^ 13 + C ((97265865897755 / 5759971954 : ℚ)) * X ^ 14 + C ((120141942521807 / 2879985977 : ℚ)) * X ^ 15 + C ((288523086302135 / 5759971954 : ℚ)) * X ^ 16 + C ((138467379916123 / 2879985977 : ℚ)) * X ^ 17 + C ((106801351943343 / 5759971954 : ℚ)) * X ^ 18
theorem CV_201_1_pre_eq :
    CV_0_re_001 * Fplus_dU_re_200 - CV_0_im_001 * Fplus_dU_im_200 = CV_201_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001, CV_0_im_001, Fplus_dU_re_200, Fplus_dU_im_200, CV_201_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_1_pim_eq :
    CV_0_re_001 * Fplus_dU_im_200 + CV_0_im_001 * Fplus_dU_re_200 = CV_201_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001, CV_0_im_001, Fplus_dU_re_200, Fplus_dU_im_200, CV_201_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_1_mul :
    CV_0_c_001 * Fplus_dU_c_200 = ofLadj CV_201_1_pre CV_201_1_pim := by
  rw [CV_0_c_001, Fplus_dU_c_200, ofLadj_mul, CV_201_1_pre_eq, CV_201_1_pim_eq]

def CV_201_2_pre : Polynomial ℚ := C ((880352265680 / 2879985977 : ℚ)) + C ((13091538100000 / 2879985977 : ℚ)) * X + C ((26543090312756 / 2879985977 : ℚ)) * X ^ 2 + C ((131066885337197 / 8639957931 : ℚ)) * X ^ 3 + C ((65047772679833 / 2879985977 : ℚ)) * X ^ 4 + C ((231527647294408 / 8639957931 : ℚ)) * X ^ 5 + C ((261401436694969 / 8639957931 : ℚ)) * X ^ 6 + C ((277648928546807 / 8639957931 : ℚ)) * X ^ 7 + C ((88166172876286 / 2879985977 : ℚ)) * X ^ 8 + C ((86492214884305 / 2879985977 : ℚ)) * X ^ 9 + C ((255670945543879 / 8639957931 : ℚ)) * X ^ 10 + C ((83854568133492 / 2879985977 : ℚ)) * X ^ 11 + C ((216396331243879 / 8639957931 : ℚ)) * X ^ 12 + C ((59949124571549 / 2879985977 : ℚ)) * X ^ 13 + C ((133431633291661 / 8639957931 : ℚ)) * X ^ 14 + C ((24641393047448 / 2879985977 : ℚ)) * X ^ 15 + C ((40274639549710 / 8639957931 : ℚ)) * X ^ 16 + C ((10400850149149 / 8639957931 : ℚ)) * X ^ 17 + C ((-8581431364964 / 8639957931 : ℚ)) * X ^ 18
def CV_201_2_pim : Polynomial ℚ := C ((-26555433904150 / 8639957931 : ℚ)) + C ((-53110867808300 / 8639957931 : ℚ)) * X + C ((-62772817833070 / 8639957931 : ℚ)) * X ^ 2 + C ((-74173138911785 / 8639957931 : ℚ)) * X ^ 3 + C ((-18542875410655 / 2879985977 : ℚ)) * X ^ 4 + C ((-6562792183286 / 2879985977 : ℚ)) * X ^ 5 + C ((9014403711739 / 8639957931 : ℚ)) * X ^ 6 + C ((51790485795035 / 8639957931 : ℚ)) * X ^ 7 + C ((76083165269473 / 8639957931 : ℚ)) * X ^ 8 + C ((75388633614473 / 8639957931 : ℚ)) * X ^ 9 + C ((72081113900786 / 8639957931 : ℚ)) * X ^ 10 + C ((31258567719120 / 2879985977 : ℚ)) * X ^ 11 + C ((115470292413934 / 8639957931 : ℚ)) * X ^ 12 + C ((40608240908339 / 2879985977 : ℚ)) * X ^ 13 + C ((132530512148732 / 8639957931 : ℚ)) * X ^ 14 + C ((116074633628746 / 8639957931 : ℚ)) * X ^ 15 + C ((84391724814004 / 8639957931 : ℚ)) * X ^ 16 + C ((60722786530535 / 8639957931 : ℚ)) * X ^ 17 + C ((22204045314604 / 8639957931 : ℚ)) * X ^ 18
theorem CV_201_2_pre_eq :
    CV_1_re_100 * Fplus_dV_re_101 - CV_1_im_100 * Fplus_dV_im_101 = CV_201_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100, CV_1_im_100, Fplus_dV_re_101, Fplus_dV_im_101, CV_201_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_2_pim_eq :
    CV_1_re_100 * Fplus_dV_im_101 + CV_1_im_100 * Fplus_dV_re_101 = CV_201_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100, CV_1_im_100, Fplus_dV_re_101, Fplus_dV_im_101, CV_201_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_2_mul :
    CV_1_c_100 * Fplus_dV_c_101 = ofLadj CV_201_2_pre CV_201_2_pim := by
  rw [CV_1_c_100, Fplus_dV_c_101, ofLadj_mul, CV_201_2_pre_eq, CV_201_2_pim_eq]

def CV_201_3_pre : Polynomial ℚ := C ((-1380250080908 / 8639957931 : ℚ)) + C ((155812553581304 / 8639957931 : ℚ)) * X + C ((207514509915181 / 5759971954 : ℚ)) * X ^ 2 + C ((507620652238705 / 8639957931 : ℚ)) * X ^ 3 + C ((286142534012460 / 2879985977 : ℚ)) * X ^ 4 + C ((366305603712034 / 2879985977 : ℚ)) * X ^ 5 + C ((883619526479659 / 5759971954 : ℚ)) * X ^ 6 + C ((1423888065862690 / 8639957931 : ℚ)) * X ^ 7 + C ((883515738989493 / 5759971954 : ℚ)) * X ^ 8 + C ((114049652086373 / 785450721 : ℚ)) * X ^ 9 + C ((2401808748877529 / 17279915862 : ℚ)) * X ^ 10 + C ((107448897910232 / 785450721 : ℚ)) * X ^ 11 + C ((2090183641714921 / 17279915862 : ℚ)) * X ^ 12 + C ((1886548816154663 / 17279915862 : ℚ)) * X ^ 13 + C ((1635305912491069 / 17279915862 : ℚ)) * X ^ 14 + C ((1062986187957959 / 17279915862 : ℚ)) * X ^ 15 + C ((659136274362625 / 17279915862 : ℚ)) * X ^ 16 + C ((103055658597926 / 8639957931 : ℚ)) * X ^ 17 + C ((-22644913230887 / 5759971954 : ℚ)) * X ^ 18
def CV_201_3_pim : Polynomial ℚ := C ((-4480600292805 / 261816907 : ℚ)) + C ((-8961200585610 / 261816907 : ℚ)) * X + C ((-764338906295455 / 17279915862 : ℚ)) * X ^ 2 + C ((-349555165396033 / 5759971954 : ℚ)) * X ^ 3 + C ((-1055130083589601 / 17279915862 : ℚ)) * X ^ 4 + C ((-774411835077115 / 17279915862 : ℚ)) * X ^ 5 + C ((-21134242660879 / 785450721 : ℚ)) * X ^ 6 + C ((65628062836085 / 8639957931 : ℚ)) * X ^ 7 + C ((226810008056717 / 8639957931 : ℚ)) * X ^ 8 + C ((144589364399333 / 5759971954 : ℚ)) * X ^ 9 + C ((170115062131664 / 8639957931 : ℚ)) * X ^ 10 + C ((249624646482818 / 8639957931 : ℚ)) * X ^ 11 + C ((329134230833972 / 8639957931 : ℚ)) * X ^ 12 + C ((122938360063078 / 2879985977 : ℚ)) * X ^ 13 + C ((1002104827355677 / 17279915862 : ℚ)) * X ^ 14 + C ((533667948114415 / 8639957931 : ℚ)) * X ^ 15 + C ((151166731299583 / 2879985977 : ℚ)) * X ^ 16 + C ((739424133099967 / 17279915862 : ℚ)) * X ^ 17 + C ((87865802989871 / 5759971954 : ℚ)) * X ^ 18
theorem CV_201_3_pre_eq :
    CV_1_re_001 * Fplus_dV_re_200 - CV_1_im_001 * Fplus_dV_im_200 = CV_201_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001, CV_1_im_001, Fplus_dV_re_200, Fplus_dV_im_200, CV_201_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_3_pim_eq :
    CV_1_re_001 * Fplus_dV_im_200 + CV_1_im_001 * Fplus_dV_re_200 = CV_201_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001, CV_1_im_001, Fplus_dV_re_200, Fplus_dV_im_200, CV_201_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_3_mul :
    CV_1_c_001 * Fplus_dV_c_200 = ofLadj CV_201_3_pre CV_201_3_pim := by
  rw [CV_1_c_001, Fplus_dV_c_200, ofLadj_mul, CV_201_3_pre_eq, CV_201_3_pim_eq]

def CV_201_4_pre : Polynomial ℚ := C ((1379902201034 / 2879985977 : ℚ)) + C ((23521795828664 / 2879985977 : ℚ)) * X + C ((140463647190839 / 8639957931 : ℚ)) * X ^ 2 + C ((227552076479096 / 8639957931 : ℚ)) * X ^ 3 + C ((115375616624996 / 2879985977 : ℚ)) * X ^ 4 + C ((418025734716067 / 8639957931 : ℚ)) * X ^ 5 + C ((484141841357591 / 8639957931 : ℚ)) * X ^ 6 + C ((528038864608102 / 8639957931 : ℚ)) * X ^ 7 + C ((519454410721252 / 8639957931 : ℚ)) * X ^ 8 + C ((526484057710741 / 8639957931 : ℚ)) * X ^ 9 + C ((177244336588833 / 2879985977 : ℚ)) * X ^ 10 + C ((176564586617288 / 2879985977 : ℚ)) * X ^ 11 + C ((153722540760169 / 2879985977 : ℚ)) * X ^ 12 + C ((386020410519902 / 8639957931 : ℚ)) * X ^ 13 + C ((26536575840196 / 785450721 : ℚ)) * X ^ 14 + C ((167005521303542 / 8639957931 : ℚ)) * X ^ 15 + C ((91281751893121 / 8639957931 : ℚ)) * X ^ 16 + C ((8388548417199 / 2879985977 : ℚ)) * X ^ 17 + C ((-14906493429572 / 8639957931 : ℚ)) * X ^ 18
def CV_201_4_pim : Polynomial ℚ := C ((-50614101266006 / 8639957931 : ℚ)) + C ((-101228202532012 / 8639957931 : ℚ)) * X + C ((-40905163952541 / 2879985977 : ℚ)) * X ^ 2 + C ((-153836260001074 / 8639957931 : ℚ)) * X ^ 3 + C ((-4047609975186 / 261816907 : ℚ)) * X ^ 4 + C ((-80918193868658 / 8639957931 : ℚ)) * X ^ 5 + C ((-13354245026908 / 2879985977 : ℚ)) * X ^ 6 + C ((11125042075132 / 2879985977 : ℚ)) * X ^ 7 + C ((75936516540106 / 8639957931 : ℚ)) * X ^ 8 + C ((76883491263470 / 8639957931 : ℚ)) * X ^ 9 + C ((81490595628056 / 8639957931 : ℚ)) * X ^ 10 + C ((46290789796458 / 2879985977 : ℚ)) * X ^ 11 + C ((17841285740972 / 785450721 : ℚ)) * X ^ 12 + C ((74116178946963 / 2879985977 : ℚ)) * X ^ 13 + C ((254416279707704 / 8639957931 : ℚ)) * X ^ 14 + C ((231262968900400 / 8639957931 : ℚ)) * X ^ 15 + C ((1940079771286 / 97078179 : ℚ)) * X ^ 16 + C ((124830365551664 / 8639957931 : ℚ)) * X ^ 17 + C ((45449570302078 / 8639957931 : ℚ)) * X ^ 18
theorem CV_201_4_pre_eq :
    CV_2_re_100 * Fplus_dW_re_101 - CV_2_im_100 * Fplus_dW_im_101 = CV_201_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100, CV_2_im_100, Fplus_dW_re_101, Fplus_dW_im_101, CV_201_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_4_pim_eq :
    CV_2_re_100 * Fplus_dW_im_101 + CV_2_im_100 * Fplus_dW_re_101 = CV_201_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100, CV_2_im_100, Fplus_dW_re_101, Fplus_dW_im_101, CV_201_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_4_mul :
    CV_2_c_100 * Fplus_dW_c_101 = ofLadj CV_201_4_pre CV_201_4_pim := by
  rw [CV_2_c_100, Fplus_dW_c_101, ofLadj_mul, CV_201_4_pre_eq, CV_201_4_pim_eq]

def CV_201_5_pre : Polynomial ℚ := C ((-1097028885110 / 261816907 : ℚ)) + C ((-86473162452432 / 2879985977 : ℚ)) * X + C ((-162981265891962 / 2879985977 : ℚ)) * X ^ 2 + C ((-1538294549933329 / 17279915862 : ℚ)) * X ^ 3 + C ((-1095075284386465 / 8639957931 : ℚ)) * X ^ 4 + C ((-836597866738463 / 5759971954 : ℚ)) * X ^ 5 + C ((-916140724723307 / 5759971954 : ℚ)) * X ^ 6 + C ((-2858441624987917 / 17279915862 : ℚ)) * X ^ 7 + C ((-1323929090522189 / 8639957931 : ℚ)) * X ^ 8 + C ((-1303865847880753 / 8639957931 : ℚ)) * X ^ 9 + C ((-78092285566283 / 523633814 : ℚ)) * X ^ 10 + C ((-1246614876647821 / 8639957931 : ℚ)) * X ^ 11 + C ((-686068816324249 / 5759971954 : ℚ)) * X ^ 12 + C ((-74083822745897 / 785450721 : ℚ)) * X ^ 13 + C ((-369854543703683 / 5759971954 : ℚ)) * X ^ 14 + C ((-494598189635465 / 17279915862 : ℚ)) * X ^ 15 + C ((-8949879394531 / 785450721 : ℚ)) * X ^ 16 + C ((20865613637425 / 8639957931 : ℚ)) * X ^ 17 + C ((28948811096587 / 2879985977 : ℚ)) * X ^ 18
def CV_201_5_pim : Polynomial ℚ := C ((116384253512782 / 8639957931 : ℚ)) + C ((232768507025564 / 8639957931 : ℚ)) * X + C ((221380457382818 / 8639957931 : ℚ)) * X ^ 2 + C ((441889930995727 / 17279915862 : ℚ)) * X ^ 3 + C ((59990375148722 / 8639957931 : ℚ)) * X ^ 4 + C ((-62866445846330 / 2879985977 : ℚ)) * X ^ 5 + C ((-758239069181173 / 17279915862 : ℚ)) * X ^ 6 + C ((-622118060593504 / 8639957931 : ℚ)) * X ^ 7 + C ((-504264889428809 / 5759971954 : ℚ)) * X ^ 8 + C ((-753521916277138 / 8639957931 : ℚ)) * X ^ 9 + C ((-740242998364948 / 8639957931 : ℚ)) * X ^ 10 + C ((-837163746325994 / 8639957931 : ℚ)) * X ^ 11 + C ((-311361498095680 / 2879985977 : ℚ)) * X ^ 12 + C ((-303139175577368 / 2879985977 : ℚ)) * X ^ 13 + C ((-906106616981074 / 8639957931 : ℚ)) * X ^ 14 + C ((-753560330760239 / 8639957931 : ℚ)) * X ^ 15 + C ((-174016276234167 / 2879985977 : ℚ)) * X ^ 16 + C ((-234527523196231 / 5759971954 : ℚ)) * X ^ 17 + C ((-125870969421403 / 8639957931 : ℚ)) * X ^ 18
theorem CV_201_5_pre_eq :
    CV_2_re_001 * Fplus_dW_re_200 - CV_2_im_001 * Fplus_dW_im_200 = CV_201_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001, CV_2_im_001, Fplus_dW_re_200, Fplus_dW_im_200, CV_201_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_5_pim_eq :
    CV_2_re_001 * Fplus_dW_im_200 + CV_2_im_001 * Fplus_dW_re_200 = CV_201_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001, CV_2_im_001, Fplus_dW_re_200, Fplus_dW_im_200, CV_201_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_5_mul :
    CV_2_c_001 * Fplus_dW_c_200 = ofLadj CV_201_5_pre CV_201_5_pim := by
  rw [CV_2_c_001, Fplus_dW_c_200, ofLadj_mul, CV_201_5_pre_eq, CV_201_5_pim_eq]

def CV_201_6_pre : Polynomial ℚ := C ((29914031770 / 785450721 : ℚ)) + C ((-27818516938 / 261816907 : ℚ)) * X ^ 2 + C ((-190623107680 / 785450721 : ℚ)) * X ^ 3 + C ((-290082204950 / 785450721 : ℚ)) * X ^ 4 + C ((-348886956860 / 785450721 : ℚ)) * X ^ 5 + C ((-348886956860 / 785450721 : ℚ)) * X ^ 6 + C ((-290082204950 / 785450721 : ℚ)) * X ^ 7 + C ((-190623107680 / 785450721 : ℚ)) * X ^ 8 + C ((-27818516938 / 261816907 : ℚ)) * X ^ 9
def CV_201_6_pim : Polynomial ℚ := C ((386459911644 / 2879985977 : ℚ)) + C ((772919823288 / 2879985977 : ℚ)) * X + C ((3087535090918 / 8639957931 : ℚ)) * X ^ 2 + C ((3276447761162 / 8639957931 : ℚ)) * X ^ 3 + C ((2751977889028 / 8639957931 : ℚ)) * X ^ 4 + C ((591824916388 / 2879985977 : ℚ)) * X ^ 5 + C ((181094906900 / 2879985977 : ℚ)) * X ^ 6 + C ((-433218419164 / 8639957931 : ℚ)) * X ^ 7 + C ((-957688291298 / 8639957931 : ℚ)) * X ^ 8 + C ((-768775621054 / 8639957931 : ℚ)) * X ^ 9
theorem CV_201_6_neg_re : -CV_3_re_201 = CV_201_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_201, CV_201_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_6_neg_im : -CV_3_im_201 = CV_201_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_201, CV_201_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_201_6_mul : -CV_3_c_201 = ofLadj CV_201_6_pre CV_201_6_pim := by
  rw [CV_3_c_201, ofLadj_neg, CV_201_6_neg_re, CV_201_6_neg_im]

def CV_coeff_201 : Ki := CV_0_c_100 * Fplus_dU_c_101 + CV_0_c_001 * Fplus_dU_c_200 + CV_1_c_100 * Fplus_dV_c_101 + CV_1_c_001 * Fplus_dV_c_200 + CV_2_c_100 * Fplus_dW_c_101 + CV_2_c_001 * Fplus_dW_c_200 + (-CV_3_c_201)

theorem CV_coeff_201_sum :
    CV_coeff_201 = ofLadj (CV_201_0_pre + CV_201_1_pre + CV_201_2_pre + CV_201_3_pre + CV_201_4_pre + CV_201_5_pre + CV_201_6_pre) (CV_201_0_pim + CV_201_1_pim + CV_201_2_pim + CV_201_3_pim + CV_201_4_pim + CV_201_5_pim + CV_201_6_pim) := by
  simp only [CV_coeff_201, CV_201_0_mul, CV_201_1_mul, CV_201_2_mul, CV_201_3_mul, CV_201_4_mul, CV_201_5_mul, CV_201_6_mul]
  simp [ofLadj_add, add_assoc]

def CV_201_qre : Polynomial ℚ := C ((-96750986960897 / 8639957931 : ℚ)) + C ((95324377815089 / 8639957931 : ℚ)) * X + C ((28949761327837 / 2879985977 : ℚ)) * X ^ 2 + C ((306354188539651 / 17279915862 : ℚ)) * X ^ 3 + C ((540225245878465 / 8639957931 : ℚ)) * X ^ 4 + C ((1059251985118825 / 17279915862 : ℚ)) * X ^ 5 + C ((100960388928523 / 1570901442 : ℚ)) * X ^ 6 + C ((261444681169869 / 5759971954 : ℚ)) * X ^ 7 + C ((98390495436104 / 8639957931 : ℚ)) * X ^ 8
def CV_201_qim : Polynomial ℚ := C ((-327151930050719 / 8639957931 : ℚ)) + C ((-327151930050719 / 8639957931 : ℚ)) * X + C ((-136036679194072 / 2879985977 : ℚ)) * X ^ 2 + C ((-51215868517130 / 785450721 : ℚ)) * X ^ 3 + C ((-364686974228339 / 8639957931 : ℚ)) * X ^ 4 + C ((-280197657351061 / 17279915862 : ℚ)) * X ^ 5 + C ((-4967701902835 / 17279915862 : ℚ)) * X ^ 6 + C ((378516515897060 / 8639957931 : ℚ)) * X ^ 7 + C ((76805570485594 / 2879985977 : ℚ)) * X ^ 8
theorem CV_coeff_201_poly_re :
    CV_201_0_pre + CV_201_1_pre + CV_201_2_pre + CV_201_3_pre + CV_201_4_pre + CV_201_5_pre + CV_201_6_pre = (0 : Polynomial ℚ) + Phi11 * CV_201_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_201_0_pre, CV_201_1_pre, CV_201_2_pre, CV_201_3_pre, CV_201_4_pre, CV_201_5_pre, CV_201_6_pre, CV_201_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_201_poly_im :
    CV_201_0_pim + CV_201_1_pim + CV_201_2_pim + CV_201_3_pim + CV_201_4_pim + CV_201_5_pim + CV_201_6_pim = (0 : Polynomial ℚ) + Phi11 * CV_201_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_201_0_pim, CV_201_1_pim, CV_201_2_pim, CV_201_3_pim, CV_201_4_pim, CV_201_5_pim, CV_201_6_pim, CV_201_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_201_eq :
    CV_coeff_201 = (0 : Ki) := by
  rw [CV_coeff_201_sum, CV_coeff_201_poly_re,
    CV_coeff_201_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
