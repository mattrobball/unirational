/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

def CW_210_0_pre : Polynomial ℚ := interpQ 17279915862 [569738476432, -27803403142512, -54819118772800, -89976069523902, -152783638891142, -194918387295368, -235954137081530, -253061471139852, -235292776745012, -223009251822588, -212933159319500, -210267369802140, -185129756176988, -168190133049788, -145316707221110, -94202632389910, -58730826284806, -17695076498644, 6075199858800]
def CW_210_0_pim : Polynomial ℚ := interpQ 17279915862 [26476717538858, 52953435077716, 68008020290178, 94203989777248, 94126615880840, 69569909992814, 42168841430698, -11458262333310, -39442055872270, -37997691203562, -29511757364588, -43784969544588, -58058181724588, -64626833098076, -89378437916438, -94313281465090, -80793242984454, -65562012450518, -22971576093900]
theorem CW_210_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_110 - CW_0_im_100 * Fplus_dU_im_110 = CW_210_0_pre := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_210_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_110 + CW_0_im_100 * Fplus_dU_re_110 = CW_210_0_pim := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_210_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_0_mul :
    CW_0_c_100 * Fplus_dU_c_110 = ofLadj CW_210_0_pre CW_210_0_pim := by
  rw [CW_0_c_100_def, Fplus_dU_c_110_def, ofLadj_mul, CW_210_0_pre_eq, CW_210_0_pim_eq]

def CW_210_1_pre : Polynomial ℚ := interpQ 17279915862 [-3455279167284, 0, 1512563889540, 6795519018294, 21907070707467, 36677435239200, 52979439387786, 65453574940215, 70024493260950, 72084003028560, 73821691781163, 77686490067702, 73821691781163, 70571439139020, 63228974242656, 46161623632170, 30449318304297, 14147314155711, 2615119399422]
def CW_210_1_pim : Polynomial ℚ := interpQ 17279915862 [-10043773249536, -20087546499072, -32114292913218, -49589382334836, -59267412778911, -64879185235524, -66001009131804, -56418284268882, -50434847914824, -50323636978809, -48963710995917, -36827168581632, -24690626167347, -11303953770309, 6282346587324, 15234039266121, 18983047211901, 18155263493091, 6709774119336]
theorem CW_210_1_pre_eq :
    CW_0_re_010 * Fplus_dU_re_200 - CW_0_im_010 * Fplus_dU_im_200 = CW_210_1_pre := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_210_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_1_pim_eq :
    CW_0_re_010 * Fplus_dU_im_200 + CW_0_im_010 * Fplus_dU_re_200 = CW_210_1_pim := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_210_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_1_mul :
    CW_0_c_010 * Fplus_dU_c_200 = ofLadj CW_210_1_pre CW_210_1_pim := by
  rw [CW_0_c_010_def, Fplus_dU_c_200_def, ofLadj_mul, CW_210_1_pre_eq, CW_210_1_pim_eq]

def CW_210_2_pre : Polynomial ℚ := interpQ 17279915862 [734869556266, -43108480874960, -80614237054168, -139313778693024, -228016119785874, -293382189815352, -358614375375130, -410088158962674, -417193889936346, -431384630593976, -443118319786378, -447638826681890, -400009838911418, -350770393539808, -277880111243322, -175620216075654, -102495241596470, -37263056036692, 6451823101146]
def CW_210_2_pim : Polynomial ℚ := interpQ 17279915862 [40028088089306, 80056176178612, 107033044127426, 151730322800232, 157729939593270, 141135361168960, 123988253759556, 74518094678294, 39093194819382, 37444385130848, 27599939796474, -26592941088358, -80785821973190, -117607135256378, -163953223617718, -164153716870090, -134756119026740, -103497201899880, -41224023399578]
theorem CW_210_2_pre_eq :
    CW_1_re_100 * Fplus_dV_re_110 - CW_1_im_100 * Fplus_dV_im_110 = CW_210_2_pre := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_210_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_2_pim_eq :
    CW_1_re_100 * Fplus_dV_im_110 + CW_1_im_100 * Fplus_dV_re_110 = CW_210_2_pim := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_210_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_2_mul :
    CW_1_c_100 * Fplus_dV_c_110 = ofLadj CW_210_2_pre CW_210_2_pim := by
  rw [CW_1_c_100_def, Fplus_dV_c_110_def, ofLadj_mul, CW_210_2_pre_eq, CW_210_2_pim_eq]

def CW_210_3_pre : Polynomial ℚ := interpQ 17279915862 [-269702159282, 4965117518440, 9722991340387, 15672789353066, 27129530484539, 34729948166966, 41741297638975, 44788494848336, 41732133290292, 39570167858320, 37684146342873, 37367894138016, 32719028824433, 29847176517933, 26059343937226, 16658880673206, 10191791994298, 3180442522289, -1000083690591]
def CW_210_3_pim : Polynomial ℚ := interpQ 17279915862 [-4776186839747, -9552373679494, -12004204407914, -16867707022964, -17089490922359, -12410972556826, -7550924804834, 1778726381023, 6734373200484, 6571653406538, 5091459702216, 7625676157258, 10159892612300, 11131529636398, 15832312457502, 16918329397805, 14196733059981, 11464142936701, 4091413778553]
theorem CW_210_3_pre_eq :
    CW_1_re_010 * Fplus_dV_re_200 - CW_1_im_010 * Fplus_dV_im_200 = CW_210_3_pre := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_210_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_3_pim_eq :
    CW_1_re_010 * Fplus_dV_im_200 + CW_1_im_010 * Fplus_dV_re_200 = CW_210_3_pim := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_210_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_3_mul :
    CW_1_c_010 * Fplus_dV_c_200 = ofLadj CW_210_3_pre CW_210_3_pim := by
  rw [CW_1_c_010_def, Fplus_dV_c_200_def, ofLadj_mul, CW_210_3_pre_eq, CW_210_3_pim_eq]

def CW_210_4_pre : Polynomial ℚ := interpQ 17279915862 [63359442226, -19918686168920, -38861988028434, -64938151838918, -97633928474638, -113712800302776, -130644691772168, -137631308782328, -131079026310874, -128542264818828, -126638989676362, -125864953295018, -106720303507442, -89680276790394, -66140874471956, -35676260686798, -21002055205528, -4070163736136, 4321119620892]
def CW_210_4_pim : Polynomial ℚ := interpQ 17279915862 [14052474611542, 28104949223084, 31733295502142, 39961826892734, 28475981298494, 12034052570282, -1706701058798, -23782055748820, -35238778885406, -34855407383200, -33225490074916, -44811980586146, -56398471097376, -58396900068150, -66242059956536, -55901780064342, -41506543304548, -30339820156144, -10311157434540]
theorem CW_210_4_pre_eq :
    CW_2_re_100 * Fplus_dW_re_110 - CW_2_im_100 * Fplus_dW_im_110 = CW_210_4_pre := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_210_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_4_pim_eq :
    CW_2_re_100 * Fplus_dW_im_110 + CW_2_im_100 * Fplus_dW_re_110 = CW_210_4_pim := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_210_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_4_mul :
    CW_2_c_100 * Fplus_dW_c_110 = ofLadj CW_210_4_pre CW_210_4_pim := by
  rw [CW_2_c_100_def, Fplus_dW_c_110_def, ofLadj_mul, CW_210_4_pre_eq, CW_210_4_pim_eq]

def CW_210_5_pre : Polynomial ℚ := interpQ 17279915862 [1603332526216, 1720661626240, 4740781641980, 5404208028784, 6218478490462, 11345082415643, 7539488169598, 10882489190638, 10544210603180, 10185868511222, 10350957556114, 8645487085734, 8630295929874, 5445086869242, 5140002574396, 4342547140914, -793220424374, 3012373821671, -321463559262]
def CW_210_5_pim : Polynomial ℚ := interpQ 17279915862 [136863303264, 273726606528, -810152046184, 3093837666762, -119826874102, 4129052693740, 6064376451387, 5142413704435, 8093711219715, 7950047474246, 7975680284564, 7713253258128, 7450826231692, 8560337694722, 4512684236307, 7914820176885, 3579780408599, 1927023569058, 2762826115566]
theorem CW_210_5_pre_eq :
    CW_2_re_010 * Fplus_dW_re_200 - CW_2_im_010 * Fplus_dW_im_200 = CW_210_5_pre := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_210_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_5_pim_eq :
    CW_2_re_010 * Fplus_dW_im_200 + CW_2_im_010 * Fplus_dW_re_200 = CW_210_5_pim := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_210_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_5_mul :
    CW_2_c_010 * Fplus_dW_c_200 = ofLadj CW_210_5_pre CW_210_5_pim := by
  rw [CW_2_c_010_def, Fplus_dW_c_200_def, ofLadj_mul, CW_210_5_pre_eq, CW_210_5_pim_eq]

def CW_210_6_pre : Polynomial ℚ := interpQ 17279915862 [-8713289068, 0, 262434735200, 431182735720, 680992073168, 807471702180, 807471702180, 680992073168, 431182735720, 262434735200]
def CW_210_6_pim : Polynomial ℚ := interpQ 17279915862 [-229931720516, -459863441032, -636634342804, -620388221784, -588095290688, -315752650352, -144110790680, 128231849656, 160524780752, 176770901772]
theorem CW_210_6_neg_re : -CW_3_re_210 = CW_210_6_pre := by
  simp only [CW_3_re_210_def, CW_210_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_6_neg_im : -CW_3_im_210 = CW_210_6_pim := by
  simp only [CW_3_im_210_def, CW_210_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_210_6_mul : -CW_3_c_210 = ofLadj CW_210_6_pre CW_210_6_pim := by
  rw [CW_3_c_210_def, ofLadj_neg, CW_210_6_neg_re, CW_210_6_neg_im]

@[expose] public def CW_coeff_210 : Ki := CW_0_c_100 * Fplus_dU_c_110 + CW_0_c_010 * Fplus_dU_c_200 + CW_1_c_100 * Fplus_dV_c_110 + CW_1_c_010 * Fplus_dV_c_200 + CW_2_c_100 * Fplus_dW_c_110 + CW_2_c_010 * Fplus_dW_c_200 + (-CW_3_c_210)

theorem CW_coeff_210_sum :
    CW_coeff_210 = ofLadj (CW_210_0_pre + CW_210_1_pre + CW_210_2_pre + CW_210_3_pre + CW_210_4_pre + CW_210_5_pre + CW_210_6_pre) (CW_210_0_pim + CW_210_1_pim + CW_210_2_pim + CW_210_3_pim + CW_210_4_pim + CW_210_5_pim + CW_210_6_pim) := by
  simp only [CW_coeff_210, CW_210_0_mul, CW_210_1_mul, CW_210_2_mul, CW_210_3_mul, CW_210_4_mul, CW_210_5_mul, CW_210_6_mul]
  simp [ofLadj_add, add_assoc]

def CW_210_qre : Polynomial ℚ := interpQ 17279915862 [-762394614494, -83382396427218, -73911781206583, -107867728671685, -156573314476038, -95955824493489, -103692067440782, -56829880502208, 18141714730407]
def CW_210_qim : Polynomial ℚ := interpQ 17279915862 [65644251733171, 65644251733171, 29920572743284, 60703423347766, -18644788650848, -54005244923450, -52443740127569, -106909861593129, -60942742914563]
theorem CW_coeff_210_poly_re :
    CW_210_0_pre + CW_210_1_pre + CW_210_2_pre + CW_210_3_pre + CW_210_4_pre + CW_210_5_pre + CW_210_6_pre = (0 : Polynomial ℚ) + Phi11 * CW_210_qre := by
  rw [phi11_interpQ]
  simp only [CW_210_0_pre, CW_210_1_pre, CW_210_2_pre, CW_210_3_pre, CW_210_4_pre, CW_210_5_pre, CW_210_6_pre, CW_210_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_210_poly_im :
    CW_210_0_pim + CW_210_1_pim + CW_210_2_pim + CW_210_3_pim + CW_210_4_pim + CW_210_5_pim + CW_210_6_pim = (0 : Polynomial ℚ) + Phi11 * CW_210_qim := by
  rw [phi11_interpQ]
  simp only [CW_210_0_pim, CW_210_1_pim, CW_210_2_pim, CW_210_3_pim, CW_210_4_pim, CW_210_5_pim, CW_210_6_pim, CW_210_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_210_eq :
    CW_coeff_210 = (0 : Ki) := by
  rw [CW_coeff_210_sum, CW_coeff_210_poly_re,
    CW_coeff_210_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
