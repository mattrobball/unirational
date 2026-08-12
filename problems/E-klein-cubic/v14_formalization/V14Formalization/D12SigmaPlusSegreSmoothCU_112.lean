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

def CU_112_0_pre : Polynomial ℚ := C ((-50539062381792 / 78598333 : ℚ)) + C ((-361470300051712 / 78598333 : ℚ)) * X + C ((-2044183568553664 / 235794999 : ℚ)) * X ^ 2 + C ((-1071180645611896 / 78598333 : ℚ)) * X ^ 3 + C ((-1525212535590064 / 78598333 : ℚ)) * X ^ 4 + C ((-5245607034695336 / 235794999 : ℚ)) * X ^ 5 + C ((-5741447970445736 / 235794999 : ℚ)) * X ^ 6 + C ((-542984966565920 / 21435909 : ℚ)) * X ^ 7 + C ((-5533461114574100 / 235794999 : ℚ)) * X ^ 8 + C ((-5449537146505916 / 235794999 : ℚ)) * X ^ 9 + C ((-5385557487122948 / 235794999 : ℚ)) * X ^ 10 + C ((-473645045795992 / 21435909 : ℚ)) * X ^ 11 + C ((-4301146586967812 / 235794999 : ℚ)) * X ^ 12 + C ((-3405353577952252 / 235794999 : ℚ)) * X ^ 13 + C ((-2319919177738412 / 235794999 : ℚ)) * X ^ 14 + C ((-344964670622848 / 78598333 : ℚ)) * X ^ 15 + C ((-136892802171200 / 78598333 : ℚ)) * X ^ 16 + C ((28387509745600 / 78598333 : ℚ)) * X ^ 17 + C ((362303013586384 / 235794999 : ℚ)) * X ^ 18
def CU_112_0_pim : Polynomial ℚ := C ((486311112820448 / 235794999 : ℚ)) + C ((972622225640896 / 235794999 : ℚ)) * X + C ((84059371211776 / 21435909 : ℚ)) * X ^ 2 + C ((921849930738728 / 235794999 : ℚ)) * X ^ 3 + C ((252006472477088 / 235794999 : ℚ)) * X ^ 4 + C ((-788683137682096 / 235794999 : ℚ)) * X ^ 5 + C ((-1584856958002600 / 235794999 : ℚ)) * X ^ 6 + C ((-866075677554816 / 78598333 : ℚ)) * X ^ 7 + C ((-3160422641695700 / 235794999 : ℚ)) * X ^ 8 + C ((-95403938141924 / 7145303 : ℚ)) * X ^ 9 + C ((-1030936821511452 / 78598333 : ℚ)) * X ^ 10 + C ((-3497866192139360 / 235794999 : ℚ)) * X ^ 11 + C ((-354811083613124 / 21435909 : ℚ)) * X ^ 12 + C ((-3799433283283868 / 235794999 : ℚ)) * X ^ 13 + C ((-1261512482560284 / 78598333 : ℚ)) * X ^ 14 + C ((-3149958626452208 / 235794999 : ℚ)) * X ^ 15 + C ((-726843435805776 / 78598333 : ℚ)) * X ^ 16 + C ((-1469039755535800 / 235794999 : ℚ)) * X ^ 17 + C ((-175643657332752 / 78598333 : ℚ)) * X ^ 18
theorem CU_112_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_101 - CU_0_im_011 * Fplus_dU_im_101 = CU_112_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_101, Fplus_dU_im_101, CU_112_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_101 + CU_0_im_011 * Fplus_dU_re_101 = CU_112_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_101, Fplus_dU_im_101, CU_112_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_0_mul :
    CU_0_c_011 * Fplus_dU_c_101 = ofLadj CU_112_0_pre CU_112_0_pim := by
  rw [CU_0_c_011, Fplus_dU_c_101, ofLadj_mul, CU_112_0_pre_eq, CU_112_0_pim_eq]

def CU_112_1_pre : Polynomial ℚ := C ((10564382646008 / 235794999 : ℚ)) + C ((-1535422874565824 / 235794999 : ℚ)) * X + C ((-279131238792872 / 21435909 : ℚ)) * X ^ 2 + C ((-1668075590991016 / 78598333 : ℚ)) * X ^ 3 + C ((-256354294109632 / 7145303 : ℚ)) * X ^ 4 + C ((-10829947091269720 / 235794999 : ℚ)) * X ^ 5 + C ((-13061028955678936 / 235794999 : ℚ)) * X ^ 6 + C ((-14031991530371920 / 235794999 : ℚ)) * X ^ 7 + C ((-13060965422062256 / 235794999 : ℚ)) * X ^ 8 + C ((-1124206842348280 / 21435909 : ℚ)) * X ^ 9 + C ((-11835865958596760 / 235794999 : ℚ)) * X ^ 10 + C ((-11648748626855392 / 235794999 : ℚ)) * X ^ 11 + C ((-3433481028010312 / 78598333 : ℚ)) * X ^ 12 + C ((-845075603555408 / 21435909 : ℚ)) * X ^ 13 + C ((-8056738649089208 / 235794999 : ℚ)) * X ^ 14 + C ((-5239696524463840 / 235794999 : ℚ)) * X ^ 15 + C ((-1082946761365368 / 78598333 : ℚ)) * X ^ 16 + C ((-30841164232936 / 7145303 : ℚ)) * X ^ 17 + C ((110867766763408 / 78598333 : ℚ)) * X ^ 18
def CU_112_1_pim : Polynomial ℚ := C ((485395490918600 / 78598333 : ℚ)) + C ((970790981837200 / 78598333 : ℚ)) * X + C ((3764869544554280 / 235794999 : ℚ)) * X ^ 2 + C ((5164507875895784 / 235794999 : ℚ)) * X ^ 3 + C ((5194281179800864 / 235794999 : ℚ)) * X ^ 4 + C ((1271584641901448 / 78598333 : ℚ)) * X ^ 5 + C ((2286346273265752 / 235794999 : ℚ)) * X ^ 6 + C ((-19575734912416 / 7145303 : ℚ)) * X ^ 7 + C ((-2237609085842560 / 235794999 : ℚ)) * X ^ 8 + C ((-712577320762728 / 78598333 : ℚ)) * X ^ 9 + C ((-1678100246361256 / 235794999 : ℚ)) * X ^ 10 + C ((-2460913503659408 / 235794999 : ℚ)) * X ^ 11 + C ((-1081242253652520 / 78598333 : ℚ)) * X ^ 12 + C ((-1212197214691104 / 78598333 : ℚ)) * X ^ 13 + C ((-4936352851860440 / 235794999 : ℚ)) * X ^ 14 + C ((-5257683289649840 / 235794999 : ℚ)) * X ^ 15 + C ((-1489531629421640 / 78598333 : ℚ)) * X ^ 16 + C ((-3641959372512392 / 235794999 : ℚ)) * X ^ 17 + C ((-433350899949504 / 78598333 : ℚ)) * X ^ 18
theorem CU_112_1_pre_eq :
    CU_0_re_002 * Fplus_dU_re_110 - CU_0_im_002 * Fplus_dU_im_110 = CU_112_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_110, Fplus_dU_im_110, CU_112_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_1_pim_eq :
    CU_0_re_002 * Fplus_dU_im_110 + CU_0_im_002 * Fplus_dU_re_110 = CU_112_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_110, Fplus_dU_im_110, CU_112_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_1_mul :
    CU_0_c_002 * Fplus_dU_c_110 = ofLadj CU_112_1_pre CU_112_1_pim := by
  rw [CU_0_c_002, Fplus_dU_c_110, ofLadj_mul, CU_112_1_pre_eq, CU_112_1_pim_eq]

def CU_112_2_pre : Polynomial ℚ := C ((89475147600328 / 235794999 : ℚ)) + C ((1211426610530080 / 235794999 : ℚ)) * X + C ((2464784406794056 / 235794999 : ℚ)) * X ^ 2 + C ((4050532288109624 / 235794999 : ℚ)) * X ^ 3 + C ((6030404830650424 / 235794999 : ℚ)) * X ^ 4 + C ((2388905573465388 / 78598333 : ℚ)) * X ^ 5 + C ((8080945081605284 / 235794999 : ℚ)) * X ^ 6 + C ((8583561574941772 / 235794999 : ℚ)) * X ^ 7 + C ((743426037770920 / 21435909 : ℚ)) * X ^ 8 + C ((8023095352970996 / 235794999 : ℚ)) * X ^ 9 + C ((7905073980749644 / 235794999 : ℚ)) * X ^ 10 + C ((7771620727986080 / 235794999 : ℚ)) * X ^ 11 + C ((2231215790073188 / 78598333 : ℚ)) * X ^ 12 + C ((5558310946176940 / 235794999 : ℚ)) * X ^ 13 + C ((1375718042456832 / 78598333 : ℚ)) * X ^ 14 + C ((763115616843356 / 78598333 : ℚ)) * X ^ 15 + C ((1237447424206688 / 235794999 : ℚ)) * X ^ 16 + C ((107739687665856 / 78598333 : ℚ)) * X ^ 17 + C ((-87936631253760 / 78598333 : ℚ)) * X ^ 18
def CU_112_2_pim : Polynomial ℚ := C ((-271921642249376 / 78598333 : ℚ)) + C ((-543843284498752 / 78598333 : ℚ)) * X + C ((-1935639614738792 / 235794999 : ℚ)) * X ^ 2 + C ((-759865806940568 / 78598333 : ℚ)) * X ^ 3 + C ((-571795089892824 / 78598333 : ℚ)) * X ^ 4 + C ((-597363119252996 / 235794999 : ℚ)) * X ^ 5 + C ((298326380699524 / 235794999 : ℚ)) * X ^ 6 + C ((1613858648647676 / 235794999 : ℚ)) * X ^ 7 + C ((2369030155108096 / 235794999 : ℚ)) * X ^ 8 + C ((782267395392724 / 78598333 : ℚ)) * X ^ 9 + C ((748171757314684 / 78598333 : ℚ)) * X ^ 10 + C ((970149678756968 / 78598333 : ℚ)) * X ^ 11 + C ((1192127600199252 / 78598333 : ℚ)) * X ^ 12 + C ((3778205647606172 / 235794999 : ℚ)) * X ^ 13 + C ((4099935484759160 / 235794999 : ℚ)) * X ^ 14 + C ((3600609837735604 / 235794999 : ℚ)) * X ^ 15 + C ((2613974682416560 / 235794999 : ℚ)) * X ^ 16 + C ((624810091727488 / 78598333 : ℚ)) * X ^ 17 + C ((230095000780248 / 78598333 : ℚ)) * X ^ 18
theorem CU_112_2_pre_eq :
    CU_1_re_011 * Fplus_dV_re_101 - CU_1_im_011 * Fplus_dV_im_101 = CU_112_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_101, Fplus_dV_im_101, CU_112_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_2_pim_eq :
    CU_1_re_011 * Fplus_dV_im_101 + CU_1_im_011 * Fplus_dV_re_101 = CU_112_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_101, Fplus_dV_im_101, CU_112_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_2_mul :
    CU_1_c_011 * Fplus_dV_c_101 = ofLadj CU_112_2_pre CU_112_2_pim := by
  rw [CU_1_c_011, Fplus_dV_c_101, ofLadj_mul, CU_112_2_pre_eq, CU_112_2_pim_eq]

def CU_112_3_pre : Polynomial ℚ := C ((-1205056310192 / 235794999 : ℚ)) + C ((-966765326103200 / 78598333 : ℚ)) * X + C ((-5491112953869016 / 235794999 : ℚ)) * X ^ 2 + C ((-3152049024208512 / 78598333 : ℚ)) * X ^ 3 + C ((-1402899465107072 / 21435909 : ℚ)) * X ^ 4 + C ((-19913080189429520 / 235794999 : ℚ)) * X ^ 5 + C ((-735603309745224 / 7145303 : ℚ)) * X ^ 6 + C ((-27792894114341168 / 235794999 : ℚ)) * X ^ 7 + C ((-28257836650359616 / 235794999 : ℚ)) * X ^ 8 + C ((-9748011241097968 / 78598333 : ℚ)) * X ^ 9 + C ((-9999015495928736 / 78598333 : ℚ)) * X ^ 10 + C ((-30276518673324832 / 235794999 : ℚ)) * X ^ 11 + C ((-9032250169825536 / 78598333 : ℚ)) * X ^ 12 + C ((-23752920769424888 / 235794999 : ℚ)) * X ^ 13 + C ((-18801689577734080 / 235794999 : ℚ)) * X ^ 14 + C ((-3973204894828528 / 78598333 : ℚ)) * X ^ 15 + C ((-6899772483044840 / 235794999 : ℚ)) * X ^ 16 + C ((-2537943450881968 / 235794999 : ℚ)) * X ^ 17 + C ((40125937607072 / 21435909 : ℚ)) * X ^ 18
def CU_112_3_pim : Polynomial ℚ := C ((2678154210465280 / 235794999 : ℚ)) + C ((5356308420930560 / 235794999 : ℚ)) * X + C ((7236614152530200 / 235794999 : ℚ)) * X ^ 2 + C ((10163769568592320 / 235794999 : ℚ)) * X ^ 3 + C ((10635516843130288 / 235794999 : ℚ)) * X ^ 4 + C ((9456782745538000 / 235794999 : ℚ)) * X ^ 5 + C ((8293499159466904 / 235794999 : ℚ)) * X ^ 6 + C ((4939468155999296 / 235794999 : ℚ)) * X ^ 7 + C ((2536143447069520 / 235794999 : ℚ)) * X ^ 8 + C ((798120403746400 / 78598333 : ℚ)) * X ^ 9 + C ((1741874892965392 / 235794999 : ℚ)) * X ^ 10 + C ((-172024094513360 / 21435909 : ℚ)) * X ^ 11 + C ((-1842134990753104 / 78598333 : ℚ)) * X ^ 12 + C ((-8059197022132760 / 235794999 : ℚ)) * X ^ 13 + C ((-11128134674025200 / 235794999 : ℚ)) * X ^ 14 + C ((-338969642768672 / 7145303 : ℚ)) * X ^ 15 + C ((-277850153771864 / 7145303 : ℚ)) * X ^ 16 + C ((-7009448488896752 / 235794999 : ℚ)) * X ^ 17 + C ((-939069482042256 / 78598333 : ℚ)) * X ^ 18
theorem CU_112_3_pre_eq :
    CU_1_re_002 * Fplus_dV_re_110 - CU_1_im_002 * Fplus_dV_im_110 = CU_112_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_110, Fplus_dV_im_110, CU_112_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_3_pim_eq :
    CU_1_re_002 * Fplus_dV_im_110 + CU_1_im_002 * Fplus_dV_re_110 = CU_112_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_110, Fplus_dV_im_110, CU_112_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_3_mul :
    CU_1_c_002 * Fplus_dV_c_110 = ofLadj CU_112_3_pre CU_112_3_pim := by
  rw [CU_1_c_002, Fplus_dV_c_110, ofLadj_mul, CU_112_3_pre_eq, CU_112_3_pim_eq]

def CU_112_4_pre : Polynomial ℚ := C ((56807497476680 / 235794999 : ℚ)) + C ((924876597203552 / 235794999 : ℚ)) * X + C ((1846816955552776 / 235794999 : ℚ)) * X ^ 2 + C ((2997562559073616 / 235794999 : ℚ)) * X ^ 3 + C ((1518360940697376 / 78598333 : ℚ)) * X ^ 4 + C ((1835803635362816 / 78598333 : ℚ)) * X ^ 5 + C ((6374301483036628 / 235794999 : ℚ)) * X ^ 6 + C ((6953122328488972 / 235794999 : ℚ)) * X ^ 7 + C ((6836764739340908 / 235794999 : ℚ)) * X ^ 8 + C ((6928462801669360 / 235794999 : ℚ)) * X ^ 9 + C ((6998582574448192 / 235794999 : ℚ)) * X ^ 10 + C ((6967877714122328 / 235794999 : ℚ)) * X ^ 11 + C ((6073705977244640 / 235794999 : ℚ)) * X ^ 12 + C ((1693881948705528 / 78598333 : ℚ)) * X ^ 13 + C ((3839202180267292 / 235794999 : ℚ)) * X ^ 14 + C ((2197340596722572 / 235794999 : ℚ)) * X ^ 15 + C ((1194869170054820 / 235794999 : ℚ)) * X ^ 16 + C ((327978593106640 / 235794999 : ℚ)) * X ^ 17 + C ((-200698909674272 / 235794999 : ℚ)) * X ^ 18
def CU_112_4_pim : Polynomial ℚ := C ((-220796760086968 / 78598333 : ℚ)) + C ((-441593520173936 / 78598333 : ℚ)) * X + C ((-1614504784208264 / 235794999 : ℚ)) * X ^ 2 + C ((-2016215685318368 / 235794999 : ℚ)) * X ^ 3 + C ((-584190145603832 / 78598333 : ℚ)) * X ^ 4 + C ((-1053870074035648 / 235794999 : ℚ)) * X ^ 5 + C ((-513767884408748 / 235794999 : ℚ)) * X ^ 6 + C ((457629858309124 / 235794999 : ℚ)) * X ^ 7 + C ((339856951696204 / 78598333 : ℚ)) * X ^ 8 + C ((1032721348740832 / 235794999 : ℚ)) * X ^ 9 + C ((364473041050648 / 78598333 : ℚ)) * X ^ 10 + C ((1844776769235616 / 235794999 : ℚ)) * X ^ 11 + C ((2596134415319288 / 235794999 : ℚ)) * X ^ 12 + C ((982185471138952 / 78598333 : ℚ)) * X ^ 13 + C ((3361417808179180 / 235794999 : ℚ)) * X ^ 14 + C ((1019777029068332 / 78598333 : ℚ)) * X ^ 15 + C ((207509592372044 / 21435909 : ℚ)) * X ^ 16 + C ((1649805420301336 / 235794999 : ℚ)) * X ^ 17 + C ((600382469246800 / 235794999 : ℚ)) * X ^ 18
theorem CU_112_4_pre_eq :
    CU_2_re_011 * Fplus_dW_re_101 - CU_2_im_011 * Fplus_dW_im_101 = CU_112_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_101, Fplus_dW_im_101, CU_112_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_4_pim_eq :
    CU_2_re_011 * Fplus_dW_im_101 + CU_2_im_011 * Fplus_dW_re_101 = CU_112_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_101, Fplus_dW_im_101, CU_112_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_4_mul :
    CU_2_c_011 * Fplus_dW_c_101 = ofLadj CU_112_4_pre CU_112_4_pim := by
  rw [CU_2_c_011, Fplus_dW_c_101, ofLadj_mul, CU_112_4_pre_eq, CU_112_4_pim_eq]

def CU_112_5_pre : Polynomial ℚ := C ((-162406086424096 / 235794999 : ℚ)) + C ((-2198340467198080 / 235794999 : ℚ)) * X + C ((-4472659065281840 / 235794999 : ℚ)) * X ^ 2 + C ((-2450535538018560 / 78598333 : ℚ)) * X ^ 3 + C ((-3648154915528768 / 78598333 : ℚ)) * X ^ 4 + C ((-13005993284252912 / 235794999 : ℚ)) * X ^ 5 + C ((-14666373683773184 / 235794999 : ℚ)) * X ^ 6 + C ((-15578007684115160 / 235794999 : ℚ)) * X ^ 7 + C ((-14840972000553016 / 235794999 : ℚ)) * X ^ 8 + C ((-4853484744888160 / 78598333 : ℚ)) * X ^ 9 + C ((-14346214976626048 / 235794999 : ℚ)) * X ^ 10 + C ((-14103913706229920 / 235794999 : ℚ)) * X ^ 11 + C ((-4049291503142656 / 78598333 : ℚ)) * X ^ 12 + C ((-10087795169382640 / 235794999 : ℚ)) * X ^ 13 + C ((-7489365386497336 / 235794999 : ℚ)) * X ^ 14 + C ((-377665802579576 / 21435909 : ℚ)) * X ^ 15 + C ((-748695844162688 / 78598333 : ℚ)) * X ^ 16 + C ((-17748700999024 / 7145303 : ℚ)) * X ^ 17 + C ((479219109153520 / 235794999 : ℚ)) * X ^ 18
def CU_112_5_pim : Polynomial ℚ := C ((493442958769536 / 78598333 : ℚ)) + C ((986885917539072 / 78598333 : ℚ)) * X + C ((3513103537474688 / 235794999 : ℚ)) * X ^ 2 + C ((4137505736201632 / 235794999 : ℚ)) * X ^ 3 + C ((3112245715441616 / 235794999 : ℚ)) * X ^ 4 + C ((1084069362078176 / 235794999 : ℚ)) * X ^ 5 + C ((-180545872578928 / 78598333 : ℚ)) * X ^ 6 + C ((-976702783280584 / 78598333 : ℚ)) * X ^ 7 + C ((-4300313996859464 / 235794999 : ℚ)) * X ^ 8 + C ((-387272280259408 / 21435909 : ℚ)) * X ^ 9 + C ((-4074419406349328 / 235794999 : ℚ)) * X ^ 10 + C ((-5282751064071584 / 235794999 : ℚ)) * X ^ 11 + C ((-6491082721793840 / 235794999 : ℚ)) * X ^ 12 + C ((-6857952830147152 / 235794999 : ℚ)) * X ^ 13 + C ((-2480678704956040 / 78598333 : ℚ)) * X ^ 14 + C ((-6534477793157944 / 235794999 : ℚ)) * X ^ 15 + C ((-4744742873866000 / 235794999 : ℚ)) * X ^ 16 + C ((-3402533246001344 / 235794999 : ℚ)) * X ^ 17 + C ((-1252503947967872 / 235794999 : ℚ)) * X ^ 18
theorem CU_112_5_pre_eq :
    CU_2_re_002 * Fplus_dW_re_110 - CU_2_im_002 * Fplus_dW_im_110 = CU_112_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_110, Fplus_dW_im_110, CU_112_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_5_pim_eq :
    CU_2_re_002 * Fplus_dW_im_110 + CU_2_im_002 * Fplus_dW_re_110 = CU_112_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_110, Fplus_dW_im_110, CU_112_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_112_5_mul :
    CU_2_c_002 * Fplus_dW_c_110 = ofLadj CU_112_5_pre CU_112_5_pim := by
  rw [CU_2_c_002, Fplus_dW_c_110, ofLadj_mul, CU_112_5_pre_eq, CU_112_5_pim_eq]

theorem CU_112_6_mul : CU_3_c_012 = ofLadj CU_3_re_012 CU_3_im_012 := rfl

def CU_coeff_112 : Ki := CU_0_c_011 * Fplus_dU_c_101 + CU_0_c_002 * Fplus_dU_c_110 + CU_1_c_011 * Fplus_dV_c_101 + CU_1_c_002 * Fplus_dV_c_110 + CU_2_c_011 * Fplus_dW_c_101 + CU_2_c_002 * Fplus_dW_c_110 + CU_3_c_012

theorem CU_coeff_112_sum :
    CU_coeff_112 = ofLadj (CU_112_0_pre + CU_112_1_pre + CU_112_2_pre + CU_112_3_pre + CU_112_4_pre + CU_112_5_pre + CU_3_re_012) (CU_112_0_pim + CU_112_1_pim + CU_112_2_pim + CU_112_3_pim + CU_112_4_pim + CU_112_5_pim + CU_3_im_012) := by
  simp only [CU_coeff_112, CU_112_0_mul, CU_112_1_mul, CU_112_2_mul, CU_112_3_mul, CU_112_4_mul, CU_112_5_mul, CU_112_6_mul]
  simp [ofLadj_add, add_assoc]

def CU_112_qre : Polynomial ℚ := C ((-161250286876480 / 235794999 : ℚ)) + C ((-5420916725618528 / 235794999 : ℚ)) * X + C ((-5176916978863376 / 235794999 : ℚ)) * X ^ 2 + C ((-7200587880154496 / 235794999 : ℚ)) * X ^ 3 + C ((-10839514881480584 / 235794999 : ℚ)) * X ^ 4 + C ((-7488779490059564 / 235794999 : ℚ)) * X ^ 5 + C ((-6968013293685460 / 235794999 : ℚ)) * X ^ 6 + C ((-4556050751468008 / 235794999 : ℚ)) * X ^ 7 + C ((1151001933272368 / 235794999 : ℚ)) * X ^ 8
def CU_112_qim : Polynomial ℚ := C ((4613049164827240 / 235794999 : ℚ)) + C ((4613049164827240 / 235794999 : ℚ)) * X + C ((2636793559776032 / 235794999 : ℚ)) * X ^ 2 + C ((4201295076882208 / 235794999 : ℚ)) * X ^ 3 + C ((-120510266603568 / 78598333 : ℚ)) * X ^ 4 + C ((-3801834050174852 / 235794999 : ℚ)) * X ^ 5 + C ((-3667597778048228 / 235794999 : ℚ)) * X ^ 6 + C ((-7392716573108624 / 235794999 : ℚ)) * X ^ 7 + C ((-4606028594353864 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_112_poly_re :
    CU_112_0_pre + CU_112_1_pre + CU_112_2_pre + CU_112_3_pre + CU_112_4_pre + CU_112_5_pre + CU_3_re_012 = (0 : Polynomial ℚ) + Phi11 * CU_112_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_112_0_pre, CU_112_1_pre, CU_112_2_pre, CU_112_3_pre, CU_112_4_pre, CU_112_5_pre, CU_3_re_012, CU_112_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_112_poly_im :
    CU_112_0_pim + CU_112_1_pim + CU_112_2_pim + CU_112_3_pim + CU_112_4_pim + CU_112_5_pim + CU_3_im_012 = (0 : Polynomial ℚ) + Phi11 * CU_112_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_112_0_pim, CU_112_1_pim, CU_112_2_pim, CU_112_3_pim, CU_112_4_pim, CU_112_5_pim, CU_3_im_012, CU_112_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_112_eq :
    CU_coeff_112 = (0 : Ki) := by
  rw [CU_coeff_112_sum, CU_coeff_112_poly_re,
    CU_coeff_112_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
