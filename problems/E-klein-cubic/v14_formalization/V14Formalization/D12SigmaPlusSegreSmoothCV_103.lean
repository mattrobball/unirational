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

def CV_103_0_pre : Polynomial ℚ := C ((-916271752456 / 8639957931 : ℚ)) + C ((8556766558592 / 8639957931 : ℚ)) * X + C ((5238845427223 / 2879985977 : ℚ)) * X ^ 2 + C ((26813607393005 / 8639957931 : ℚ)) * X ^ 3 + C ((41120237612930 / 8639957931 : ℚ)) * X ^ 4 + C ((49649824813286 / 8639957931 : ℚ)) * X ^ 5 + C ((57423403250251 / 8639957931 : ℚ)) * X ^ 6 + C ((126090093351749 / 17279915862 : ℚ)) * X ^ 7 + C ((122465761852853 / 17279915862 : ℚ)) * X ^ 8 + C ((20545829082146 / 2879985977 : ℚ)) * X ^ 9 + C ((41911897492197 / 5759971954 : ℚ)) * X ^ 10 + C ((63436385787239 / 8639957931 : ℚ)) * X ^ 11 + C ((108622159359407 / 17279915862 : ℚ)) * X ^ 12 + C ((15306983654923 / 2879985977 : ℚ)) * X ^ 13 + C ((68838547066843 / 17279915862 : ℚ)) * X ^ 14 + C ((37995380692241 / 17279915862 : ℚ)) * X ^ 15 + C ((10173956562344 / 8639957931 : ℚ)) * X ^ 16 + C ((800126041793 / 2879985977 : ℚ)) * X ^ 17 + C ((-2927118716824 / 8639957931 : ℚ)) * X ^ 18
def CV_103_0_pim : Polynomial ℚ := C ((-6689014265548 / 8639957931 : ℚ)) + C ((-13378028531096 / 8639957931 : ℚ)) * X + C ((-15805364496265 / 8639957931 : ℚ)) * X ^ 2 + C ((-6645988047617 / 2879985977 : ℚ)) * X ^ 3 + C ((-550127697965 / 261816907 : ℚ)) * X ^ 4 + C ((-10462013343475 / 8639957931 : ℚ)) * X ^ 5 + C ((-7417811576437 / 8639957931 : ℚ)) * X ^ 6 + C ((585226028825 / 1570901442 : ℚ)) * X ^ 7 + C ((1302256833071 / 1570901442 : ℚ)) * X ^ 8 + C ((7653693304396 / 8639957931 : ℚ)) * X ^ 9 + C ((15957277961005 / 17279915862 : ℚ)) * X ^ 10 + C ((5201731894620 / 2879985977 : ℚ)) * X ^ 11 + C ((46463504774435 / 17279915862 : ℚ)) * X ^ 12 + C ((25984034028493 / 8639957931 : ℚ)) * X ^ 13 + C ((61215828795169 / 17279915862 : ℚ)) * X ^ 14 + C ((55924966993387 / 17279915862 : ℚ)) * X ^ 15 + C ((225869084894 / 97078179 : ℚ)) * X ^ 16 + C ((15609839200970 / 8639957931 : ℚ)) * X ^ 17 + C ((1601783404746 / 2879985977 : ℚ)) * X ^ 18
theorem CV_103_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_002 - CV_0_im_101 * Fplus_dU_im_002 = CV_103_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_103_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_002 + CV_0_im_101 * Fplus_dU_re_002 = CV_103_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_103_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_0_mul :
    CV_0_c_101 * Fplus_dU_c_002 = ofLadj CV_103_0_pre CV_103_0_pim := by
  rw [CV_0_c_101_def, Fplus_dU_c_002_def, ofLadj_mul, CV_103_0_pre_eq, CV_103_0_pim_eq]

def CV_103_1_pre : Polynomial ℚ := C ((107019393411664 / 2879985977 : ℚ)) + C ((69466389023360 / 261816907 : ℚ)) * X + C ((1440514002559248 / 2879985977 : ℚ)) * X ^ 2 + C ((6796124636172580 / 8639957931 : ℚ)) * X ^ 3 + C ((9675017418654448 / 8639957931 : ℚ)) * X ^ 4 + C ((11090173363146604 / 8639957931 : ℚ)) * X ^ 5 + C ((12141256674127598 / 8639957931 : ℚ)) * X ^ 6 + C ((4209745080570168 / 2879985977 : ℚ)) * X ^ 7 + C ((1063594461200192 / 785450721 : ℚ)) * X ^ 8 + C ((11522022486998828 / 8639957931 : ℚ)) * X ^ 9 + C ((11386828679123338 / 8639957931 : ℚ)) * X ^ 10 + C ((11015065749797368 / 8639957931 : ℚ)) * X ^ 11 + C ((9094437841352458 / 8639957931 : ℚ)) * X ^ 12 + C ((7200480479321084 / 8639957931 : ℚ)) * X ^ 13 + C ((1634471479009844 / 2879985977 : ℚ)) * X ^ 14 + C ((2187358236282728 / 8639957931 : ℚ)) * X ^ 15 + C ((869115710601410 / 8639957931 : ℚ)) * X ^ 16 + C ((-181967600379584 / 8639957931 : ℚ)) * X ^ 17 + C ((-255619862257776 / 2879985977 : ℚ)) * X ^ 18
def CV_103_1_pim : Polynomial ℚ := C ((-342557638989744 / 2879985977 : ℚ)) + C ((-685115277979488 / 2879985977 : ℚ)) * X + C ((-651851331201088 / 2879985977 : ℚ)) * X ^ 2 + C ((-1949098630823348 / 8639957931 : ℚ)) * X ^ 3 + C ((-176763768886072 / 2879985977 : ℚ)) * X ^ 4 + C ((1668212209689836 / 8639957931 : ℚ)) * X ^ 5 + C ((1117371661063594 / 2879985977 : ℚ)) * X ^ 6 + C ((5496757280553148 / 8639957931 : ℚ)) * X ^ 7 + C ((6684623828139724 / 8639957931 : ℚ)) * X ^ 8 + C ((2219756098114240 / 2879985977 : ℚ)) * X ^ 9 + C ((6541852637123014 / 8639957931 : ℚ)) * X ^ 10 + C ((7397655164226608 / 8639957931 : ℚ)) * X ^ 11 + C ((2751152563776734 / 2879985977 : ℚ)) * X ^ 12 + C ((8036250193775296 / 8639957931 : ℚ)) * X ^ 13 + C ((8004439297198376 / 8639957931 : ℚ)) * X ^ 14 + C ((2219961419191444 / 2879985977 : ℚ)) * X ^ 15 + C ((4612302778210246 / 8639957931 : ℚ)) * X ^ 16 + C ((3107334523423888 / 8639957931 : ℚ)) * X ^ 17 + C ((371204754348496 / 2879985977 : ℚ)) * X ^ 18
theorem CV_103_1_pre_eq :
    CV_0_re_002 * Fplus_dU_re_101 - CV_0_im_002 * Fplus_dU_im_101 = CV_103_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_103_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_1_pim_eq :
    CV_0_re_002 * Fplus_dU_im_101 + CV_0_im_002 * Fplus_dU_re_101 = CV_103_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_103_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_1_mul :
    CV_0_c_002 * Fplus_dU_c_101 = ofLadj CV_103_1_pre CV_103_1_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_101_def, ofLadj_mul, CV_103_1_pre_eq, CV_103_1_pim_eq]

def CV_103_2_pre : Polynomial ℚ := C ((19496428249 / 194156358 : ℚ)) + C ((-6771299890 / 8825289 : ℚ)) * X + C ((-306287535551 / 194156358 : ℚ)) * X ^ 2 + C ((-179034806281 / 64718786 : ℚ)) * X ^ 3 + C ((-857297245745 / 194156358 : ℚ)) * X ^ 4 + C ((-1114039463099 / 194156358 : ℚ)) * X ^ 5 + C ((-656452411555 / 97078179 : ℚ)) * X ^ 6 + C ((-1371285925861 / 194156358 : ℚ)) * X ^ 7 + C ((-1232457224947 / 194156358 : ℚ)) * X ^ 8 + C ((-1135928229035 / 194156358 : ℚ)) * X ^ 9 + C ((-533701648760 / 97078179 : ℚ)) * X ^ 10 + C ((-528520482223 / 97078179 : ℚ)) * X ^ 11 + C ((-153072449990 / 32359393 : ℚ)) * X ^ 12 + C ((-138273448914 / 32359393 : ℚ)) * X ^ 13 + C ((-31606945732 / 8825289 : ℚ)) * X ^ 14 + C ((-230097652205 / 97078179 : ℚ)) * X ^ 15 + C ((-128087828384 / 97078179 : ℚ)) * X ^ 16 + C ((-57310296757 / 194156358 : ℚ)) * X ^ 17 + C ((26896687853 / 97078179 : ℚ)) * X ^ 18
def CV_103_2_pim : Polynomial ℚ := C ((54384413997 / 64718786 : ℚ)) + C ((54384413997 / 32359393 : ℚ)) * X + C ((401667686297 / 194156358 : ℚ)) * X ^ 2 + C ((512463967943 / 194156358 : ℚ)) * X ^ 3 + C ((506377759819 / 194156358 : ℚ)) * X ^ 4 + C ((118016992669 / 64718786 : ℚ)) * X ^ 5 + C ((81607752797 / 97078179 : ℚ)) * X ^ 6 + C ((-127512321631 / 194156358 : ℚ)) * X ^ 7 + C ((-271691172463 / 194156358 : ℚ)) * X ^ 8 + C ((-86586886593 / 64718786 : ℚ)) * X ^ 9 + C ((-98076141128 / 97078179 : ℚ)) * X ^ 10 + C ((-134390050318 / 97078179 : ℚ)) * X ^ 11 + C ((-56901319836 / 32359393 : ℚ)) * X ^ 12 + C ((-58860123968 / 32359393 : ℚ)) * X ^ 13 + C ((-226013256385 / 97078179 : ℚ)) * X ^ 14 + C ((-241351589063 / 97078179 : ℚ)) * X ^ 15 + C ((-68907299819 / 32359393 : ℚ)) * X ^ 16 + C ((-315076401977 / 194156358 : ℚ)) * X ^ 17 + C ((-17902662892 / 32359393 : ℚ)) * X ^ 18
theorem CV_103_2_pre_eq :
    CV_1_re_101 * Fplus_dV_re_002 - CV_1_im_101 * Fplus_dV_im_002 = CV_103_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_103_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_2_pim_eq :
    CV_1_re_101 * Fplus_dV_im_002 + CV_1_im_101 * Fplus_dV_re_002 = CV_103_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_103_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_2_mul :
    CV_1_c_101 * Fplus_dV_c_002 = ofLadj CV_103_2_pre CV_103_2_pim := by
  rw [CV_1_c_101_def, Fplus_dV_c_002_def, ofLadj_mul, CV_103_2_pre_eq, CV_103_2_pim_eq]

def CV_103_3_pre : Polynomial ℚ := C ((-162656994564532 / 8639957931 : ℚ)) + C ((-2172416260930000 / 8639957931 : ℚ)) * X + C ((-1473861328868000 / 2879985977 : ℚ)) * X ^ 2 + C ((-7264547823348220 / 8639957931 : ℚ)) * X ^ 3 + C ((-10814608898575004 / 8639957931 : ℚ)) * X ^ 4 + C ((-4284147103718902 / 2879985977 : ℚ)) * X ^ 5 + C ((-14492554967351686 / 8639957931 : ℚ)) * X ^ 6 + C ((-15393318777132892 / 8639957931 : ℚ)) * X ^ 7 + C ((-14666535819513098 / 8639957931 : ℚ)) * X ^ 8 + C ((-14389773053663108 / 8639957931 : ℚ)) * X ^ 9 + C ((-4725903707760500 / 2879985977 : ℚ)) * X ^ 10 + C ((-13936677758518472 / 8639957931 : ℚ)) * X ^ 11 + C ((-12005294862351500 / 8639957931 : ℚ)) * X ^ 12 + C ((-9968189067059108 / 8639957931 : ℚ)) * X ^ 13 + C ((-7401987996164878 / 8639957931 : ℚ)) * X ^ 14 + C ((-1368967849438564 / 2879985977 : ℚ)) * X ^ 15 + C ((-201846667971280 / 785450721 : ℚ)) * X ^ 16 + C ((-580199691489100 / 8639957931 : ℚ)) * X ^ 17 + C ((471806330242196 / 8639957931 : ℚ)) * X ^ 18
def CV_103_3_pim : Polynomial ℚ := C ((1461969369336320 / 8639957931 : ℚ)) + C ((2923938738672640 / 8639957931 : ℚ)) * X + C ((315441196901332 / 785450721 : ℚ)) * X ^ 2 + C ((4085848700483540 / 8639957931 : ℚ)) * X ^ 3 + C ((3073241770411892 / 8639957931 : ℚ)) * X ^ 4 + C ((1070253838430710 / 8639957931 : ℚ)) * X ^ 5 + C ((-538193576314142 / 8639957931 : ℚ)) * X ^ 6 + C ((-87729372635980 / 261816907 : ℚ)) * X ^ 7 + C ((-1416822083622634 / 2879985977 : ℚ)) * X ^ 8 + C ((-4210281260533828 / 8639957931 : ℚ)) * X ^ 9 + C ((-1342376191592064 / 2879985977 : ℚ)) * X ^ 10 + C ((-1740126068129740 / 2879985977 : ℚ)) * X ^ 11 + C ((-2137875944667416 / 2879985977 : ℚ)) * X ^ 12 + C ((-2258796525162208 / 2879985977 : ℚ)) * X ^ 13 + C ((-7352200119721438 / 8639957931 : ℚ)) * X ^ 14 + C ((-6456321583136852 / 8639957931 : ℚ)) * X ^ 15 + C ((-1562803252092704 / 2879985977 : ℚ)) * X ^ 16 + C ((-3360468175944256 / 8639957931 : ℚ)) * X ^ 17 + C ((-1238668560393500 / 8639957931 : ℚ)) * X ^ 18
theorem CV_103_3_pre_eq :
    CV_1_re_002 * Fplus_dV_re_101 - CV_1_im_002 * Fplus_dV_im_101 = CV_103_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_103_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_3_pim_eq :
    CV_1_re_002 * Fplus_dV_im_101 + CV_1_im_002 * Fplus_dV_re_101 = CV_103_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_103_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_3_mul :
    CV_1_c_002 * Fplus_dV_c_101 = ofLadj CV_103_3_pre CV_103_3_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_101_def, ofLadj_mul, CV_103_3_pre_eq, CV_103_3_pim_eq]

def CV_103_4_pre : Polynomial ℚ := C ((795804609605 / 2879985977 : ℚ)) + C ((-2111032756947 / 2879985977 : ℚ)) * X ^ 2 + C ((-9769846513177 / 5759971954 : ℚ)) * X ^ 3 + C ((-14841395360073 / 5759971954 : ℚ)) * X ^ 4 + C ((-8928264412715 / 2879985977 : ℚ)) * X ^ 5 + C ((-8928264412715 / 2879985977 : ℚ)) * X ^ 6 + C ((-14841395360073 / 5759971954 : ℚ)) * X ^ 7 + C ((-9769846513177 / 5759971954 : ℚ)) * X ^ 8 + C ((-2111032756947 / 2879985977 : ℚ)) * X ^ 9
def CV_103_4_pim : Polynomial ℚ := C ((2684032276055 / 2879985977 : ℚ)) + C ((5368064552110 / 2879985977 : ℚ)) * X + C ((7198188619866 / 2879985977 : ℚ)) * X ^ 2 + C ((15190853398967 / 5759971954 : ℚ)) * X ^ 3 + C ((12857121557893 / 5759971954 : ℚ)) * X ^ 4 + C ((4080809257827 / 2879985977 : ℚ)) * X ^ 5 + C ((1287255294283 / 2879985977 : ℚ)) * X ^ 6 + C ((-2120992453673 / 5759971954 : ℚ)) * X ^ 7 + C ((-4454724294747 / 5759971954 : ℚ)) * X ^ 8 + C ((-1830124067756 / 2879985977 : ℚ)) * X ^ 9
theorem CV_103_4_pre_eq :
    CV_2_re_101 * Fplus_dW_re_002 - CV_2_im_101 * Fplus_dW_im_002 = CV_103_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_103_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_4_pim_eq :
    CV_2_re_101 * Fplus_dW_im_002 + CV_2_im_101 * Fplus_dW_re_002 = CV_103_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_103_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_4_mul :
    CV_2_c_101 * Fplus_dW_c_002 = ofLadj CV_103_4_pre CV_103_4_pim := by
  rw [CV_2_c_101_def, Fplus_dW_c_002_def, ofLadj_mul, CV_103_4_pre_eq, CV_103_4_pim_eq]

def CV_103_5_pre : Polynomial ℚ := C ((-66825194126936 / 8639957931 : ℚ)) + C ((-1139632422495392 / 8639957931 : ℚ)) * X + C ((-6259860024220 / 23801537 : ℚ)) * X ^ 2 + C ((-3693075417057208 / 8639957931 : ℚ)) * X ^ 3 + C ((-5612689186668500 / 8639957931 : ℚ)) * X ^ 4 + C ((-2261561873040124 / 2879985977 : ℚ)) * X ^ 5 + C ((-2618201477954312 / 2879985977 : ℚ)) * X ^ 6 + C ((-8567346878696944 / 8639957931 : ℚ)) * X ^ 7 + C ((-765624285731342 / 785450721 : ℚ)) * X ^ 8 + C ((-2844711713609496 / 2879985977 : ℚ)) * X ^ 9 + C ((-8621616080049722 / 8639957931 : ℚ)) * X ^ 10 + C ((-8585830903534480 / 8639957931 : ℚ)) * X ^ 11 + C ((-2493994552518110 / 2879985977 : ℚ)) * X ^ 12 + C ((-2087268650678876 / 2879985977 : ℚ)) * X ^ 13 + C ((-1576263908662518 / 2879985977 : ℚ)) * X ^ 14 + C ((-2704531562524252 / 8639957931 : ℚ)) * X ^ 15 + C ((-133731212345408 / 785450721 : ℚ)) * X ^ 16 + C ((-401124521056924 / 8639957931 : ℚ)) * X ^ 17 + C ((250126129504192 / 8639957931 : ℚ)) * X ^ 18
def CV_103_5_pim : Polynomial ℚ := C ((272476954723480 / 2879985977 : ℚ)) + C ((544953909446960 / 2879985977 : ℚ)) * X + C ((663930086173452 / 2879985977 : ℚ)) * X ^ 2 + C ((2488801940916040 / 8639957931 : ℚ)) * X ^ 3 + C ((721020706141108 / 2879985977 : ℚ)) * X ^ 4 + C ((433568134584828 / 2879985977 : ℚ)) * X ^ 5 + C ((638431744793264 / 8639957931 : ℚ)) * X ^ 6 + C ((-51249694164356 / 785450721 : ℚ)) * X ^ 7 + C ((-1253135037946810 / 8639957931 : ℚ)) * X ^ 8 + C ((-1270178397259676 / 8639957931 : ℚ)) * X ^ 9 + C ((-1344561316476754 / 8639957931 : ℚ)) * X ^ 10 + C ((-68844228821864 / 261816907 : ℚ)) * X ^ 11 + C ((-3199157785766270 / 8639957931 : ℚ)) * X ^ 12 + C ((-3630469235162824 / 8639957931 : ℚ)) * X ^ 13 + C ((-125591644753678 / 261816907 : ℚ)) * X ^ 14 + C ((-3770310119010328 / 8639957931 : ℚ)) * X ^ 15 + C ((-957742815108 / 2941763 : ℚ)) * X ^ 16 + C ((-2035102874477696 / 8639957931 : ℚ)) * X ^ 17 + C ((-737862737507224 / 8639957931 : ℚ)) * X ^ 18
theorem CV_103_5_pre_eq :
    CV_2_re_002 * Fplus_dW_re_101 - CV_2_im_002 * Fplus_dW_im_101 = CV_103_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_103_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_5_pim_eq :
    CV_2_re_002 * Fplus_dW_im_101 + CV_2_im_002 * Fplus_dW_re_101 = CV_103_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_103_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_103_5_mul :
    CV_2_c_002 * Fplus_dW_c_101 = ofLadj CV_103_5_pre CV_103_5_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_101_def, ofLadj_mul, CV_103_5_pre_eq, CV_103_5_pim_eq]

@[expose] public def CV_coeff_103 : Ki := CV_0_c_101 * Fplus_dU_c_002 + CV_0_c_002 * Fplus_dU_c_101 + CV_1_c_101 * Fplus_dV_c_002 + CV_1_c_002 * Fplus_dV_c_101 + CV_2_c_101 * Fplus_dW_c_002 + CV_2_c_002 * Fplus_dW_c_101

theorem CV_coeff_103_sum :
    CV_coeff_103 = ofLadj (CV_103_0_pre + CV_103_1_pre + CV_103_2_pre + CV_103_3_pre + CV_103_4_pre + CV_103_5_pre) (CV_103_0_pim + CV_103_1_pim + CV_103_2_pim + CV_103_3_pim + CV_103_4_pim + CV_103_5_pim) := by
  simp only [CV_coeff_103, CV_103_0_mul, CV_103_1_mul, CV_103_2_mul, CV_103_3_mul, CV_103_4_mul, CV_103_5_mul]
  simpa [add_assoc] using ofLadj_add6 CV_103_0_pre CV_103_0_pim CV_103_1_pre CV_103_1_pim CV_103_2_pre CV_103_2_pim CV_103_3_pre CV_103_3_pim CV_103_4_pre CV_103_4_pim CV_103_5_pre CV_103_5_pim

def CV_103_qre : Polynomial ℚ := C ((62609816451309 / 5759971954 : ℚ)) + C ((-2223289812730387 / 17279915862 : ℚ)) * X + C ((-905924895567385 / 5759971954 : ℚ)) * X ^ 2 + C ((-1197748925472543 / 5759971954 : ℚ)) * X ^ 3 + C ((-2598331336203766 / 8639957931 : ℚ)) * X ^ 4 + C ((-3604182084422701 / 17279915862 : ℚ)) * X ^ 5 + C ((-3320050180080149 / 17279915862 : ℚ)) * X ^ 6 + C ((-2235962604962137 / 17279915862 : ℚ)) * X ^ 7 + C ((-15153480174949 / 2879985977 : ℚ)) * X ^ 8
def CV_103_qim : Polynomial ℚ := C ((2520701436737489 / 17279915862 : ℚ)) + C ((2520701436737489 / 17279915862 : ℚ)) * X + C ((2018102814995609 / 17279915862 : ℚ)) * X ^ 2 + C ((67966795689091 / 523633814 : ℚ)) * X ^ 3 + C ((2377966293565 / 261816907 : ℚ)) * X ^ 4 + C ((-1345943451933185 / 17279915862 : ℚ)) * X ^ 5 + C ((-1201291877702197 / 17279915862 : ℚ)) * X ^ 6 + C ((-2847511784103817 / 17279915862 : ℚ)) * X ^ 7 + C ((-287630565211054 / 2879985977 : ℚ)) * X ^ 8
theorem CV_coeff_103_poly_re :
    CV_103_0_pre + CV_103_1_pre + CV_103_2_pre + CV_103_3_pre + CV_103_4_pre + CV_103_5_pre = (0 : Polynomial ℚ) + Phi11 * CV_103_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_103_0_pre, CV_103_1_pre, CV_103_2_pre, CV_103_3_pre, CV_103_4_pre, CV_103_5_pre, CV_103_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_103_poly_im :
    CV_103_0_pim + CV_103_1_pim + CV_103_2_pim + CV_103_3_pim + CV_103_4_pim + CV_103_5_pim = (0 : Polynomial ℚ) + Phi11 * CV_103_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_103_0_pim, CV_103_1_pim, CV_103_2_pim, CV_103_3_pim, CV_103_4_pim, CV_103_5_pim, CV_103_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_103_eq :
    CV_coeff_103 = (0 : Ki) := by
  rw [CV_coeff_103_sum, CV_coeff_103_poly_re,
    CV_coeff_103_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
