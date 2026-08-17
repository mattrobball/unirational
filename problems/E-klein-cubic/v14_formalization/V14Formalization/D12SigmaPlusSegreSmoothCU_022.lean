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

def CU_022_0_pre : Polynomial ℚ := C ((33302443503888 / 78598333 : ℚ)) + C ((451837875064640 / 78598333 : ℚ)) * X + C ((2757779185953712 / 235794999 : ℚ)) * X ^ 2 + C ((4530107909092336 / 235794999 : ℚ)) * X ^ 3 + C ((2248458462217808 / 78598333 : ℚ)) * X ^ 4 + C ((8017220532543544 / 235794999 : ℚ)) * X ^ 5 + C ((821673710465800 / 21435909 : ℚ)) * X ^ 6 + C ((9601234969122976 / 235794999 : ℚ)) * X ^ 7 + C ((9147871338909368 / 235794999 : ℚ)) * X ^ 8 + C ((815897725993928 / 21435909 : ℚ)) * X ^ 9 + C ((2947645269835352 / 78598333 : ℚ)) * X ^ 10 + C ((8693943902513824 / 235794999 : ℚ)) * X ^ 11 + C ((226891581342792 / 7145303 : ℚ)) * X ^ 12 + C ((2072365266659832 / 78598333 : ℚ)) * X ^ 13 + C ((419796675437912 / 21435909 : ℚ)) * X ^ 14 + C ((853807112451472 / 78598333 : ℚ)) * X ^ 15 + C ((461287145678944 / 78598333 : ℚ)) * X ^ 16 + C ((362671154456576 / 235794999 : ℚ)) * X ^ 17 + C ((-294438245115136 / 235794999 : ℚ)) * X ^ 18
def CU_022_0_pim : Polynomial ℚ := C ((-912879456694192 / 235794999 : ℚ)) + C ((-1825758913388384 / 235794999 : ℚ)) * X + C ((-721672819567904 / 78598333 : ℚ)) * X ^ 2 + C ((-2549921811642256 / 235794999 : ℚ)) * X ^ 3 + C ((-1920418206334832 / 235794999 : ℚ)) * X ^ 4 + C ((-222919609058568 / 78598333 : ℚ)) * X ^ 5 + C ((332858915481704 / 235794999 : ℚ)) * X ^ 6 + C ((1803040815283744 / 235794999 : ℚ)) * X ^ 7 + C ((2648051969780824 / 235794999 : ℚ)) * X ^ 8 + C ((874382884061880 / 78598333 : ℚ)) * X ^ 9 + C ((2508645781710496 / 235794999 : ℚ)) * X ^ 10 + C ((3254033999389216 / 235794999 : ℚ)) * X ^ 11 + C ((3999422217067936 / 235794999 : ℚ)) * X ^ 12 + C ((1408059630636040 / 78598333 : ℚ)) * X ^ 13 + C ((1528059642417160 / 78598333 : ℚ)) * X ^ 14 + C ((1342450510620704 / 78598333 : ℚ)) * X ^ 15 + C ((2922662025175232 / 235794999 : ℚ)) * X ^ 16 + C ((2095546971908816 / 235794999 : ℚ)) * X ^ 17 + C ((772334944579024 / 235794999 : ℚ)) * X ^ 18
theorem CU_022_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_011 - CU_0_im_011 * Fplus_dU_im_011 = CU_022_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_011, Fplus_dU_im_011, CU_022_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_011 + CU_0_im_011 * Fplus_dU_re_011 = CU_022_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_011, Fplus_dU_im_011, CU_022_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_0_mul :
    CU_0_c_011 * Fplus_dU_c_011 = ofLadj CU_022_0_pre CU_022_0_pim := by
  rw [CU_0_c_011, Fplus_dU_c_011, ofLadj_mul, CU_022_0_pre_eq, CU_022_0_pim_eq]

def CU_022_1_pre : Polynomial ℚ := C ((-293651293776 / 78598333 : ℚ)) + C ((-1919278593207280 / 235794999 : ℚ)) * X + C ((-1211288913713552 / 78598333 : ℚ)) * X ^ 2 + C ((-6258225541312520 / 235794999 : ℚ)) * X ^ 3 + C ((-3404223754766176 / 78598333 : ℚ)) * X ^ 4 + C ((-13178155184763496 / 235794999 : ℚ)) * X ^ 5 + C ((-16065147570154912 / 235794999 : ℚ)) * X ^ 6 + C ((-6131065056562792 / 78598333 : ℚ)) * X ^ 7 + C ((-6233575829289176 / 78598333 : ℚ)) * X ^ 8 + C ((-19353459126000328 / 235794999 : ℚ)) * X ^ 9 + C ((-19851768763284080 / 235794999 : ℚ)) * X ^ 10 + C ((-20036570027658208 / 235794999 : ℚ)) * X ^ 11 + C ((-17932490170076800 / 235794999 : ℚ)) * X ^ 12 + C ((-15719592384859672 / 235794999 : ℚ)) * X ^ 13 + C ((-12442501946555008 / 235794999 : ℚ)) * X ^ 14 + C ((-2629406548321112 / 78598333 : ℚ)) * X ^ 15 + C ((-4566334330266736 / 235794999 : ℚ)) * X ^ 16 + C ((-152667449534120 / 21435909 : ℚ)) * X ^ 17 + C ((97434753475504 / 78598333 : ℚ)) * X ^ 18
def CU_022_1_pim : Polynomial ℚ := C ((14646703521608 / 1948719 : ℚ)) + C ((29293407043216 / 1948719 : ℚ)) * X + C ((4789105639131904 / 235794999 : ℚ)) * X ^ 2 + C ((6726102572647600 / 235794999 : ℚ)) * X ^ 3 + C ((639816599042912 / 21435909 : ℚ)) * X ^ 4 + C ((2086067024459072 / 78598333 : ℚ)) * X ^ 5 + C ((5488260204739976 / 235794999 : ℚ)) * X ^ 6 + C ((3268231832766400 / 235794999 : ℚ)) * X ^ 7 + C ((50842068707592 / 7145303 : ℚ)) * X ^ 8 + C ((1583929690935008 / 235794999 : ℚ)) * X ^ 9 + C ((1152042277410256 / 235794999 : ℚ)) * X ^ 10 + C ((-1252827216027344 / 235794999 : ℚ)) * X ^ 11 + C ((-3657696709464944 / 235794999 : ℚ)) * X ^ 12 + C ((-1778062503297488 / 78598333 : ℚ)) * X ^ 13 + C ((-7365043019823688 / 235794999 : ℚ)) * X ^ 14 + C ((-7402945715570704 / 235794999 : ℚ)) * X ^ 15 + C ((-2022805352140160 / 78598333 : ℚ)) * X ^ 16 + C ((-4639197401522264 / 235794999 : ℚ)) * X ^ 17 + C ((-1864420886493280 / 235794999 : ℚ)) * X ^ 18
theorem CU_022_1_pre_eq :
    CU_0_re_002 * Fplus_dU_re_020 - CU_0_im_002 * Fplus_dU_im_020 = CU_022_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_020, Fplus_dU_im_020, CU_022_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_1_pim_eq :
    CU_0_re_002 * Fplus_dU_im_020 + CU_0_im_002 * Fplus_dU_re_020 = CU_022_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_020, Fplus_dU_im_020, CU_022_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_1_mul :
    CU_0_c_002 * Fplus_dU_c_020 = ofLadj CU_022_1_pre CU_022_1_pim := by
  rw [CU_0_c_002, Fplus_dU_c_020, ofLadj_mul, CU_022_1_pre_eq, CU_022_1_pim_eq]

def CU_022_2_pre : Polynomial ℚ := C ((-243417696446512 / 235794999 : ℚ)) + C ((-3391994509484224 / 235794999 : ℚ)) * X + C ((-2243404395199072 / 78598333 : ℚ)) * X ^ 2 + C ((-11028585558283168 / 235794999 : ℚ)) * X ^ 3 + C ((-16447597172717944 / 235794999 : ℚ)) * X ^ 4 + C ((-19590586210092208 / 235794999 : ℚ)) * X ^ 5 + C ((-22159503167481776 / 235794999 : ℚ)) * X ^ 6 + C ((-23703411836853904 / 235794999 : ℚ)) * X ^ 7 + C ((-22588290713393104 / 235794999 : ℚ)) * X ^ 8 + C ((-7444347475000424 / 78598333 : ℚ)) * X ^ 9 + C ((-22138109413383152 / 235794999 : ℚ)) * X ^ 10 + C ((-7274051247509312 / 78598333 : ℚ)) * X ^ 11 + C ((-18746114903898928 / 235794999 : ℚ)) * X ^ 12 + C ((-5200943079801352 / 78598333 : ℚ)) * X ^ 13 + C ((-31844917782672 / 649573 : ℚ)) * X ^ 14 + C ((-2125108998441120 / 78598333 : ℚ)) * X ^ 15 + C ((-3371685835793344 / 235794999 : ℚ)) * X ^ 16 + C ((-267589626134592 / 78598333 : ℚ)) * X ^ 17 + C ((293495889604200 / 78598333 : ℚ)) * X ^ 18
def CU_022_2_pim : Polynomial ℚ := C ((2308370327105360 / 235794999 : ℚ)) + C ((4616740654210720 / 235794999 : ℚ)) * X + C ((5415766434079304 / 235794999 : ℚ)) * X ^ 2 + C ((6502022707660168 / 235794999 : ℚ)) * X ^ 3 + C ((4989283958870360 / 235794999 : ℚ)) * X ^ 4 + C ((1925477256318160 / 235794999 : ℚ)) * X ^ 5 + C ((-189826401811584 / 78598333 : ℚ)) * X ^ 6 + C ((-4303373966287432 / 235794999 : ℚ)) * X ^ 7 + C ((-6487730800912520 / 235794999 : ℚ)) * X ^ 8 + C ((-6451058380595272 / 235794999 : ℚ)) * X ^ 9 + C ((-2094035194350592 / 78598333 : ℚ)) * X ^ 10 + C ((-8343085559243344 / 235794999 : ℚ)) * X ^ 11 + C ((-945824139584992 / 21435909 : ℚ)) * X ^ 12 + C ((-11034138517760000 / 235794999 : ℚ)) * X ^ 13 + C ((-4027907457007872 / 78598333 : ℚ)) * X ^ 14 + C ((-970736337105280 / 21435909 : ℚ)) * X ^ 15 + C ((-7831316272997792 / 235794999 : ℚ)) * X ^ 16 + C ((-1864704080720528 / 78598333 : ℚ)) * X ^ 17 + C ((-692413582900272 / 78598333 : ℚ)) * X ^ 18
theorem CU_022_2_pre_eq :
    CU_1_re_011 * Fplus_dV_re_011 - CU_1_im_011 * Fplus_dV_im_011 = CU_022_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_011, Fplus_dV_im_011, CU_022_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_2_pim_eq :
    CU_1_re_011 * Fplus_dV_im_011 + CU_1_im_011 * Fplus_dV_re_011 = CU_022_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_011, Fplus_dV_im_011, CU_022_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_2_mul :
    CU_1_c_011 * Fplus_dV_c_011 = ofLadj CU_022_2_pre CU_022_2_pim := by
  rw [CU_1_c_011, Fplus_dV_c_011, ofLadj_mul, CU_022_2_pre_eq, CU_022_2_pim_eq]

def CU_022_3_pre : Polynomial ℚ := C ((5441249759512 / 7145303 : ℚ)) + C ((580059195661920 / 78598333 : ℚ)) * X + C ((1009901371838024 / 78598333 : ℚ)) * X ^ 2 + C ((1630988375147256 / 78598333 : ℚ)) * X ^ 3 + C ((224018814280136 / 7145303 : ℚ)) * X ^ 4 + C ((2801642801352512 / 78598333 : ℚ)) * X ^ 5 + C ((3213490703209048 / 78598333 : ℚ)) * X ^ 6 + C ((3688063368478920 / 78598333 : ℚ)) * X ^ 7 + C ((3776362490670872 / 78598333 : ℚ)) * X ^ 8 + C ((4071253969269736 / 78598333 : ℚ)) * X ^ 9 + C ((4296406293205592 / 78598333 : ℚ)) * X ^ 10 + C ((4320484691395936 / 78598333 : ℚ)) * X ^ 11 + C ((3716347097543672 / 78598333 : ℚ)) * X ^ 12 + C ((3061352597431712 / 78598333 : ℚ)) * X ^ 13 + C ((2145374115523616 / 78598333 : ℚ)) * X ^ 14 + C ((1041156224770776 / 78598333 : ℚ)) * X ^ 15 + C ((542654909150632 / 78598333 : ℚ)) * X ^ 16 + C ((130807007294096 / 78598333 : ℚ)) * X ^ 17 + C ((-182700186626648 / 78598333 : ℚ)) * X ^ 18
def CU_022_3_pim : Polynomial ℚ := C ((-332610123611384 / 78598333 : ℚ)) + C ((-665220247222768 / 78598333 : ℚ)) * X + C ((-766221044524432 / 78598333 : ℚ)) * X ^ 2 + C ((-90362793091192 / 7145303 : ℚ)) * X ^ 3 + C ((-747364256850216 / 78598333 : ℚ)) * X ^ 4 + C ((-336885524546720 / 78598333 : ℚ)) * X ^ 5 + C ((-226893282106472 / 78598333 : ℚ)) * X ^ 6 + C ((190731029274256 / 78598333 : ℚ)) * X ^ 7 + C ((508592926770608 / 78598333 : ℚ)) * X ^ 8 + C ((550992921231968 / 78598333 : ℚ)) * X ^ 9 + C ((746092178800008 / 78598333 : ℚ)) * X ^ 10 + C ((1364553640554656 / 78598333 : ℚ)) * X ^ 11 + C ((1983015102309304 / 78598333 : ℚ)) * X ^ 12 + C ((2279115157179008 / 78598333 : ℚ)) * X ^ 13 + C ((231753166465368 / 7145303 : ℚ)) * X ^ 14 + C ((2178894712350528 / 78598333 : ℚ)) * X ^ 15 + C ((1517788357409832 / 78598333 : ℚ)) * X ^ 16 + C ((1109877483129904 / 78598333 : ℚ)) * X ^ 17 + C ((441625549111976 / 78598333 : ℚ)) * X ^ 18
theorem CU_022_3_pre_eq :
    CU_1_re_002 * Fplus_dV_re_020 - CU_1_im_002 * Fplus_dV_im_020 = CU_022_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_020, Fplus_dV_im_020, CU_022_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_3_pim_eq :
    CU_1_re_002 * Fplus_dV_im_020 + CU_1_im_002 * Fplus_dV_re_020 = CU_022_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_020, Fplus_dV_im_020, CU_022_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_3_mul :
    CU_1_c_002 * Fplus_dV_c_020 = ofLadj CU_022_3_pre CU_022_3_pim := by
  rw [CU_1_c_002, Fplus_dV_c_020, ofLadj_mul, CU_022_3_pre_eq, CU_022_3_pim_eq]

def CU_022_4_pre : Polynomial ℚ := C ((-5726837806840 / 235794999 : ℚ)) + C ((132125228171936 / 235794999 : ℚ)) * X + C ((282156339792680 / 235794999 : ℚ)) * X ^ 2 + C ((481853587248256 / 235794999 : ℚ)) * X ^ 3 + C ((767293902927824 / 235794999 : ℚ)) * X ^ 4 + C ((992995781997184 / 235794999 : ℚ)) * X ^ 5 + C ((1169165107671952 / 235794999 : ℚ)) * X ^ 6 + C ((1221434865054064 / 235794999 : ℚ)) * X ^ 7 + C ((100351994728592 / 21435909 : ℚ)) * X ^ 8 + C ((92841921900088 / 21435909 : ℚ)) * X ^ 9 + C ((29030802333136 / 7145303 : ℚ)) * X ^ 10 + C ((313391635358368 / 78598333 : ℚ)) * X ^ 11 + C ((825891248821552 / 235794999 : ℚ)) * X ^ 12 + C ((246368267036096 / 78598333 : ℚ)) * X ^ 13 + C ((207339451588752 / 78598333 : ℚ)) * X ^ 14 + C ((412596386273888 / 235794999 : ℚ)) * X ^ 15 + C ((232150691443904 / 235794999 : ℚ)) * X ^ 16 + C ((55981365769136 / 235794999 : ℚ)) * X ^ 17 + C ((-13848191950784 / 78598333 : ℚ)) * X ^ 18
def CU_022_4_pim : Polynomial ℚ := C ((-1172022846152 / 1948719 : ℚ)) + C ((-2344045692304 / 1948719 : ℚ)) * X + C ((-31969553031800 / 21435909 : ℚ)) * X ^ 2 + C ((-148749231656776 / 78598333 : ℚ)) * X ^ 3 + C ((-437511666188768 / 235794999 : ℚ)) * X ^ 4 + C ((-308450338719272 / 235794999 : ℚ)) * X ^ 5 + C ((-43512015201632 / 78598333 : ℚ)) * X ^ 6 + C ((114342134202368 / 235794999 : ℚ)) * X ^ 7 + C ((83196631163016 / 78598333 : ℚ)) * X ^ 8 + C ((237760094665864 / 235794999 : ℚ)) * X ^ 9 + C ((183087358861928 / 235794999 : ℚ)) * X ^ 10 + C ((244664505866240 / 235794999 : ℚ)) * X ^ 11 + C ((306241652870552 / 235794999 : ℚ)) * X ^ 12 + C ((106534823882544 / 78598333 : ℚ)) * X ^ 13 + C ((134119094814992 / 78598333 : ℚ)) * X ^ 14 + C ((428219939276672 / 235794999 : ℚ)) * X ^ 15 + C ((369491998672760 / 235794999 : ℚ)) * X ^ 16 + C ((91731289538368 / 78598333 : ℚ)) * X ^ 17 + C ((100649075673424 / 235794999 : ℚ)) * X ^ 18
theorem CU_022_4_pre_eq :
    CU_2_re_011 * Fplus_dW_re_011 - CU_2_im_011 * Fplus_dW_im_011 = CU_022_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_011, Fplus_dW_im_011, CU_022_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_4_pim_eq :
    CU_2_re_011 * Fplus_dW_im_011 + CU_2_im_011 * Fplus_dW_re_011 = CU_022_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_011, Fplus_dW_im_011, CU_022_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_4_mul :
    CU_2_c_011 * Fplus_dW_c_011 = ofLadj CU_022_4_pre CU_022_4_pim := by
  rw [CU_2_c_011, Fplus_dW_c_011, ofLadj_mul, CU_022_4_pre_eq, CU_022_4_pim_eq]

def CU_022_5_pre : Polynomial ℚ := C ((220915537154144 / 235794999 : ℚ)) + C ((3077676654077312 / 235794999 : ℚ)) * X + C ((6106396788261200 / 235794999 : ℚ)) * X ^ 2 + C ((3336116591123872 / 78598333 : ℚ)) * X ^ 3 + C ((4975071488457584 / 78598333 : ℚ)) * X ^ 4 + C ((5925399923522048 / 78598333 : ℚ)) * X ^ 5 + C ((166190919356024 / 1948719 : ℚ)) * X ^ 6 + C ((7169750862934192 / 78598333 : ℚ)) * X ^ 7 + C ((6832254098841784 / 78598333 : ℚ)) * X ^ 8 + C ((6755059454853144 / 78598333 : ℚ)) * X ^ 9 + C ((6696093952917376 / 78598333 : ℚ)) * X ^ 10 + C ((19801367114015600 / 235794999 : ℚ)) * X ^ 11 + C ((17010605204674816 / 235794999 : ℚ)) * X ^ 12 + C ((14158781576298232 / 235794999 : ℚ)) * X ^ 13 + C ((3496137507717912 / 78598333 : ℚ)) * X ^ 14 + C ((5784398901365264 / 235794999 : ℚ)) * X ^ 15 + C ((3060015064019960 / 235794999 : ℚ)) * X ^ 16 + C ((242371197502400 / 78598333 : ℚ)) * X ^ 17 + C ((-799639222064560 / 235794999 : ℚ)) * X ^ 18
def CU_022_5_pim : Polynomial ℚ := C ((-2094443831504032 / 235794999 : ℚ)) + C ((-4188887663008064 / 235794999 : ℚ)) * X + C ((-4914705569766848 / 235794999 : ℚ)) * X ^ 2 + C ((-1966876219159728 / 78598333 : ℚ)) * X ^ 3 + C ((-1508684559972536 / 78598333 : ℚ)) * X ^ 4 + C ((-1747216125736232 / 235794999 : ℚ)) * X ^ 5 + C ((172340562977120 / 78598333 : ℚ)) * X ^ 6 + C ((1302221965704976 / 78598333 : ℚ)) * X ^ 7 + C ((5888340298508248 / 235794999 : ℚ)) * X ^ 8 + C ((5855059587640816 / 235794999 : ℚ)) * X ^ 9 + C ((5701872037197032 / 235794999 : ℚ)) * X ^ 10 + C ((229446022032608 / 7145303 : ℚ)) * X ^ 11 + C ((9441565416955096 / 235794999 : ℚ)) * X ^ 12 + C ((10014195773270096 / 235794999 : ℚ)) * X ^ 13 + C ((3655612716705000 / 78598333 : ℚ)) * X ^ 14 + C ((880856181701440 / 21435909 : ℚ)) * X ^ 15 + C ((7107435177444736 / 235794999 : ℚ)) * X ^ 16 + C ((5077309050504200 / 235794999 : ℚ)) * X ^ 17 + C ((1884519575230904 / 235794999 : ℚ)) * X ^ 18
theorem CU_022_5_pre_eq :
    CU_2_re_002 * Fplus_dW_re_020 - CU_2_im_002 * Fplus_dW_im_020 = CU_022_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_020, Fplus_dW_im_020, CU_022_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_5_pim_eq :
    CU_2_re_002 * Fplus_dW_im_020 + CU_2_im_002 * Fplus_dW_re_020 = CU_022_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_020, Fplus_dW_im_020, CU_022_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_022_5_mul :
    CU_2_c_002 * Fplus_dW_c_020 = ofLadj CU_022_5_pre CU_022_5_pim := by
  rw [CU_2_c_002, Fplus_dW_c_020, ofLadj_mul, CU_022_5_pre_eq, CU_022_5_pim_eq]

@[expose] public def CU_coeff_022 : Ki := CU_0_c_011 * Fplus_dU_c_011 + CU_0_c_002 * Fplus_dU_c_020 + CU_1_c_011 * Fplus_dV_c_011 + CU_1_c_002 * Fplus_dV_c_020 + CU_2_c_011 * Fplus_dW_c_011 + CU_2_c_002 * Fplus_dW_c_020

theorem CU_coeff_022_sum :
    CU_coeff_022 = ofLadj (CU_022_0_pre + CU_022_1_pre + CU_022_2_pre + CU_022_3_pre + CU_022_4_pre + CU_022_5_pre) (CU_022_0_pim + CU_022_1_pim + CU_022_2_pim + CU_022_3_pim + CU_022_4_pim + CU_022_5_pim) := by
  simp only [CU_coeff_022, CU_022_0_mul, CU_022_1_mul, CU_022_2_mul, CU_022_3_mul, CU_022_4_mul, CU_022_5_mul]
  simpa [add_assoc] using ofLadj_add6 CU_022_0_pre CU_022_0_pim CU_022_1_pre CU_022_1_pim CU_022_2_pre CU_022_2_pim CU_022_3_pre CU_022_3_pim CU_022_4_pre CU_022_4_pim CU_022_5_pre CU_022_5_pim

def CU_022_qre : Polynomial ℚ := C ((83452873865008 / 78598333 : ℚ)) + C ((743861370142400 / 235794999 : ℚ)) * X + C ((272578837015456 / 78598333 : ℚ)) * X ^ 2 + C ((271502930924832 / 78598333 : ℚ)) * X ^ 3 + C ((543770893623728 / 235794999 : ℚ)) * X ^ 4 + C ((-747633094873312 / 235794999 : ℚ)) * X ^ 5 + C ((-690104557443592 / 235794999 : ℚ)) * X ^ 6 + C ((-432993014991016 / 235794999 : ℚ)) * X ^ 7 + C ((-510930673672880 / 235794999 : ℚ)) * X ^ 8
def CU_022_qim : Polynomial ℚ := C ((-22115656732280 / 78598333 : ℚ)) + C ((-22115656732280 / 78598333 : ℚ)) * X + C ((202504589403744 / 78598333 : ℚ)) * X ^ 2 + C ((874535116389112 / 235794999 : ℚ)) * X ^ 3 + C ((1551835281143872 / 235794999 : ℚ)) * X ^ 4 + C ((1547406239073472 / 235794999 : ℚ)) * X ^ 5 + C ((508849247369968 / 235794999 : ℚ)) * X ^ 6 + C ((403654089108800 / 235794999 : ℚ)) * X ^ 7 + C ((46906202541728 / 78598333 : ℚ)) * X ^ 8
theorem CU_coeff_022_poly_re :
    CU_022_0_pre + CU_022_1_pre + CU_022_2_pre + CU_022_3_pre + CU_022_4_pre + CU_022_5_pre = (0 : Polynomial ℚ) + Phi11 * CU_022_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_022_0_pre, CU_022_1_pre, CU_022_2_pre, CU_022_3_pre, CU_022_4_pre, CU_022_5_pre, CU_022_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_022_poly_im :
    CU_022_0_pim + CU_022_1_pim + CU_022_2_pim + CU_022_3_pim + CU_022_4_pim + CU_022_5_pim = (0 : Polynomial ℚ) + Phi11 * CU_022_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_022_0_pim, CU_022_1_pim, CU_022_2_pim, CU_022_3_pim, CU_022_4_pim, CU_022_5_pim, CU_022_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CU_coeff_022_eq :
    CU_coeff_022 = (0 : Ki) := by
  rw [CU_coeff_022_sum, CU_coeff_022_poly_re,
    CU_coeff_022_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
