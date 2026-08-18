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

def CU_112_0_pre : Polynomial ℚ := interpQ 235794999 [-151617187145376, -1084410900155136, -2044183568553664, -3213541936835688, -4575637606770192, -5245607034695336, -5741447970445736, -5972834632225120, -5533461114574100, -5449537146505916, -5385557487122948, -5210095503755912, -4301146586967812, -3405353577952252, -2319919177738412, -1034894011868544, -410678406513600, 85162529236800, 362303013586384]
def CU_112_0_pim : Polynomial ℚ := interpQ 235794999 [486311112820448, 972622225640896, 924653083329536, 921849930738728, 252006472477088, -788683137682096, -1584856958002600, -2598227032664448, -3160422641695700, -3148329958683492, -3092810464534356, -3497866192139360, -3902921919744364, -3799433283283868, -3784537447680852, -3149958626452208, -2180530307417328, -1469039755535800, -526930971998256]
theorem CU_112_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_101 - CU_0_im_011 * Fplus_dU_im_101 = CU_112_0_pre := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_112_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_101 + CU_0_im_011 * Fplus_dU_re_101 = CU_112_0_pim := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_112_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_0_mul :
    CU_0_c_011 * Fplus_dU_c_101 = ofLadj CU_112_0_pre CU_112_0_pim := by
  rw [CU_0_c_011_def, Fplus_dU_c_101_def, ofLadj_mul, CU_112_0_pre_eq, CU_112_0_pim_eq]

def CU_112_1_pre : Polynomial ℚ := interpQ 235794999 [10564382646008, -1535422874565824, -3070443626721592, -5004226772973048, -8459691705617856, -10829947091269720, -13061028955678936, -14031991530371920, -13060965422062256, -12366275265831080, -11835865958596760, -11648748626855392, -10300443084030936, -9295831639109488, -8056738649089208, -5239696524463840, -3248840284096104, -1017758419686888, 332603300290224]
def CU_112_1_pim : Polynomial ℚ := interpQ 235794999 [1456186472755800, 2912372945511600, 3764869544554280, 5164507875895784, 5194281179800864, 3814753925704344, 2286346273265752, -645999252109728, -2237609085842560, -2137731962288184, -1678100246361256, -2460913503659408, -3243726760957560, -3636591644073312, -4936352851860440, -5257683289649840, -4468594888264920, -3641959372512392, -1300052699848512]
theorem CU_112_1_pre_eq :
    CU_0_re_002 * Fplus_dU_re_110 - CU_0_im_002 * Fplus_dU_im_110 = CU_112_1_pre := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_112_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_1_pim_eq :
    CU_0_re_002 * Fplus_dU_im_110 + CU_0_im_002 * Fplus_dU_re_110 = CU_112_1_pim := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_112_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_1_mul :
    CU_0_c_002 * Fplus_dU_c_110 = ofLadj CU_112_1_pre CU_112_1_pim := by
  rw [CU_0_c_002_def, Fplus_dU_c_110_def, ofLadj_mul, CU_112_1_pre_eq, CU_112_1_pim_eq]

def CU_112_2_pre : Polynomial ℚ := interpQ 235794999 [89475147600328, 1211426610530080, 2464784406794056, 4050532288109624, 6030404830650424, 7166716720396164, 8080945081605284, 8583561574941772, 8177686415480120, 8023095352970996, 7905073980749644, 7771620727986080, 6693647370219564, 5558310946176940, 4127154127370496, 2289346850530068, 1237447424206688, 323219062997568, -263809893761280]
def CU_112_2_pim : Polynomial ℚ := interpQ 235794999 [-815764926748128, -1631529853496256, -1935639614738792, -2279597420821704, -1715385269678472, -597363119252996, 298326380699524, 1613858648647676, 2369030155108096, 2346802186178172, 2244515271944052, 2910449036270904, 3576382800597756, 3778205647606172, 4099935484759160, 3600609837735604, 2613974682416560, 1874430275182464, 690285002340744]
theorem CU_112_2_pre_eq :
    CU_1_re_011 * Fplus_dV_re_101 - CU_1_im_011 * Fplus_dV_im_101 = CU_112_2_pre := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_112_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_2_pim_eq :
    CU_1_re_011 * Fplus_dV_im_101 + CU_1_im_011 * Fplus_dV_re_101 = CU_112_2_pim := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_112_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_2_mul :
    CU_1_c_011 * Fplus_dV_c_101 = ofLadj CU_112_2_pre CU_112_2_pim := by
  rw [CU_1_c_011_def, Fplus_dV_c_101_def, ofLadj_mul, CU_112_2_pre_eq, CU_112_2_pim_eq]

def CU_112_3_pre : Polynomial ℚ := interpQ 235794999 [-1205056310192, -2900295978309600, -5491112953869016, -9456147072625536, -15431894116177792, -19913080189429520, -24274909221592392, -27792894114341168, -28257836650359616, -29244033723293904, -29997046487786208, -30276518673324832, -27096750509476608, -23752920769424888, -18801689577734080, -11919614684485584, -6899772483044840, -2537943450881968, 441385313677792]
def CU_112_3_pim : Polynomial ℚ := interpQ 235794999 [2678154210465280, 5356308420930560, 7236614152530200, 10163769568592320, 10635516843130288, 9456782745538000, 8293499159466904, 4939468155999296, 2536143447069520, 2394361211239200, 1741874892965392, -1892265039646960, -5526404972259312, -8059197022132760, -11128134674025200, -11185998211366176, -9169055074471512, -7009448488896752, -2817208446126768]
theorem CU_112_3_pre_eq :
    CU_1_re_002 * Fplus_dV_re_110 - CU_1_im_002 * Fplus_dV_im_110 = CU_112_3_pre := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_112_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_3_pim_eq :
    CU_1_re_002 * Fplus_dV_im_110 + CU_1_im_002 * Fplus_dV_re_110 = CU_112_3_pim := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_112_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_3_mul :
    CU_1_c_002 * Fplus_dV_c_110 = ofLadj CU_112_3_pre CU_112_3_pim := by
  rw [CU_1_c_002_def, Fplus_dV_c_110_def, ofLadj_mul, CU_112_3_pre_eq, CU_112_3_pim_eq]

def CU_112_4_pre : Polynomial ℚ := interpQ 235794999 [56807497476680, 924876597203552, 1846816955552776, 2997562559073616, 4555082822092128, 5507410906088448, 6374301483036628, 6953122328488972, 6836764739340908, 6928462801669360, 6998582574448192, 6967877714122328, 6073705977244640, 5081645846116584, 3839202180267292, 2197340596722572, 1194869170054820, 327978593106640, -200698909674272]
def CU_112_4_pim : Polynomial ℚ := interpQ 235794999 [-662390280260904, -1324780560521808, -1614504784208264, -2016215685318368, -1752570436811496, -1053870074035648, -513767884408748, 457629858309124, 1019570855088612, 1032721348740832, 1093419123151944, 1844776769235616, 2596134415319288, 2946556413416856, 3361417808179180, 3059331087204996, 2282605516092484, 1649805420301336, 600382469246800]
theorem CU_112_4_pre_eq :
    CU_2_re_011 * Fplus_dW_re_101 - CU_2_im_011 * Fplus_dW_im_101 = CU_112_4_pre := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_112_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_4_pim_eq :
    CU_2_re_011 * Fplus_dW_im_101 + CU_2_im_011 * Fplus_dW_re_101 = CU_112_4_pim := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_112_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_4_mul :
    CU_2_c_011 * Fplus_dW_c_101 = ofLadj CU_112_4_pre CU_112_4_pim := by
  rw [CU_2_c_011_def, Fplus_dW_c_101_def, ofLadj_mul, CU_112_4_pre_eq, CU_112_4_pim_eq]

def CU_112_5_pre : Polynomial ℚ := interpQ 235794999 [-162406086424096, -2198340467198080, -4472659065281840, -7351606614055680, -10944464746586304, -13005993284252912, -14666373683773184, -15578007684115160, -14840972000553016, -14560454234664480, -14346214976626048, -14103913706229920, -12147874509427968, -10087795169382640, -7489365386497336, -4154323828375336, -2246087532488064, -585707132967792, 479219109153520]
def CU_112_5_pim : Polynomial ℚ := interpQ 235794999 [1480328876308608, 2960657752617216, 3513103537474688, 4137505736201632, 3112245715441616, 1084069362078176, -541637617736784, -2930108349841752, -4300313996859464, -4259995082853488, -4074419406349328, -5282751064071584, -6491082721793840, -6857952830147152, -7442036114868120, -6534477793157944, -4744742873866000, -3402533246001344, -1252503947967872]
theorem CU_112_5_pre_eq :
    CU_2_re_002 * Fplus_dW_re_110 - CU_2_im_002 * Fplus_dW_im_110 = CU_112_5_pre := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_112_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_5_pim_eq :
    CU_2_re_002 * Fplus_dW_im_110 + CU_2_im_002 * Fplus_dW_re_110 = CU_112_5_pim := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_112_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_112_5_mul :
    CU_2_c_002 * Fplus_dW_c_110 = ofLadj CU_112_5_pre CU_112_5_pim := by
  rw [CU_2_c_002_def, Fplus_dW_c_110_def, ofLadj_mul, CU_112_5_pre_eq, CU_112_5_pim_eq]

theorem CU_112_6_mul : CU_3_c_012 = ofLadj CU_3_re_012 CU_3_im_012 := CU_3_c_012_def

@[expose] public def CU_coeff_112 : Ki := CU_0_c_011 * Fplus_dU_c_101 + CU_0_c_002 * Fplus_dU_c_110 + CU_1_c_011 * Fplus_dV_c_101 + CU_1_c_002 * Fplus_dV_c_110 + CU_2_c_011 * Fplus_dW_c_101 + CU_2_c_002 * Fplus_dW_c_110 + CU_3_c_012

theorem CU_coeff_112_sum :
    CU_coeff_112 = ofLadj (CU_112_0_pre + CU_112_1_pre + CU_112_2_pre + CU_112_3_pre + CU_112_4_pre + CU_112_5_pre + CU_3_re_012) (CU_112_0_pim + CU_112_1_pim + CU_112_2_pim + CU_112_3_pim + CU_112_4_pim + CU_112_5_pim + CU_3_im_012) := by
  simp only [CU_coeff_112, CU_112_0_mul, CU_112_1_mul, CU_112_2_mul, CU_112_3_mul, CU_112_4_mul, CU_112_5_mul, CU_112_6_mul]
  simp [ofLadj_add, add_assoc]

def CU_112_qre : Polynomial ℚ := interpQ 235794999 [-161250286876480, -5420916725618528, -5176916978863376, -7200587880154496, -10839514881480584, -7488779490059564, -6968013293685460, -4556050751468008, 1151001933272368]
def CU_112_qim : Polynomial ℚ := interpQ 235794999 [4613049164827240, 4613049164827240, 2636793559776032, 4201295076882208, -361530799810704, -3801834050174852, -3667597778048228, -7392716573108624, -4606028594353864]
theorem CU_coeff_112_poly_re :
    CU_112_0_pre + CU_112_1_pre + CU_112_2_pre + CU_112_3_pre + CU_112_4_pre + CU_112_5_pre + CU_3_re_012 = (0 : Polynomial ℚ) + Phi11 * CU_112_qre := by
  rw [phi11_interpQ]
  simp only [CU_112_0_pre, CU_112_1_pre, CU_112_2_pre, CU_112_3_pre, CU_112_4_pre, CU_112_5_pre, CU_3_re_012_def, CU_112_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_112_poly_im :
    CU_112_0_pim + CU_112_1_pim + CU_112_2_pim + CU_112_3_pim + CU_112_4_pim + CU_112_5_pim + CU_3_im_012 = (0 : Polynomial ℚ) + Phi11 * CU_112_qim := by
  rw [phi11_interpQ]
  simp only [CU_112_0_pim, CU_112_1_pim, CU_112_2_pim, CU_112_3_pim, CU_112_4_pim, CU_112_5_pim, CU_3_im_012_def, CU_112_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_112_eq :
    CU_coeff_112 = (0 : Ki) := by
  rw [CU_coeff_112_sum, CU_coeff_112_poly_re,
    CU_coeff_112_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
