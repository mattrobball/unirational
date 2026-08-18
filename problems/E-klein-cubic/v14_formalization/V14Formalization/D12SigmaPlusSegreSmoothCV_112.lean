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

def CV_112_0_pre : Polynomial ℚ := interpQ 8639957931 [-1017963132832, 12223952226560, 23179799187562, 39831748857014, 59681502198374, 70852203107190, 79611190502686, 85185304244106, 80012997613062, 78045092185923, 77259881215639, 77347196521412, 65035928989079, 54865292998361, 40181248756048, 21524046566174, 11334157245852, 2575169850356, -3979755479558]
def CV_112_0_pim : Polynomial ℚ := interpQ 8639957931 [-9031850998216, -18063701996432, -20885137913170, -24996934475458, -19989341114936, -7221302662502, -623031019468, 14648507667756, 20872613573236, 20980605151741, 19714072543695, 27270031526328, 34825990508961, 36380893817653, 40600681958446, 35859761203938, 24918744592642, 19401950145552, 5957433299466]
theorem CV_112_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_011 - CV_0_im_101 * Fplus_dU_im_011 = CV_112_0_pre := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_112_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_011 + CV_0_im_101 * Fplus_dU_re_011 = CV_112_0_pim := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_112_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_0_mul :
    CV_0_c_101 * Fplus_dU_c_011 = ofLadj CV_112_0_pre CV_112_0_pim := by
  rw [CV_0_c_101_def, Fplus_dU_c_011_def, ofLadj_mul, CV_112_0_pre_eq, CV_112_0_pim_eq]

def CV_112_1_pre : Polynomial ℚ := interpQ 8639957931 [3748631343828, -573097709442720, -1146169465187220, -1867581809910006, -3157148637852804, -4041906434540188, -4874255347297858, -5236711432221092, -4874474880084514, -4615341068433144, -4417339116008536, -4347423064489948, -3844241406565816, -3469171603245924, -3006893070174508, -1955629276550456, -1212456638622012, -380107725864342, 123933517817832]
def CV_112_1_pim : Polynomial ℚ := interpQ 8639957931 [543467083963668, 1086934167927336, 1405070655625260, 1927341321496510, 1938543234883624, 1423715644845072, 853135041317850, -240626186337056, -834795368302802, -797380952762132, -625952165785556, -918130013212232, -1210307860638908, -1357015561360256, -1841871811690836, -1961998612434960, -1667325974913004, -1358850569747046, -485244294608736]
theorem CV_112_1_pre_eq :
    CV_0_re_002 * Fplus_dU_re_110 - CV_0_im_002 * Fplus_dU_im_110 = CV_112_1_pre := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_112_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_1_pim_eq :
    CV_0_re_002 * Fplus_dU_im_110 + CV_0_im_002 * Fplus_dU_re_110 = CV_112_1_pim := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_112_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_1_mul :
    CV_0_c_002 * Fplus_dU_c_110 = ofLadj CV_112_1_pre CV_112_1_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_110_def, ofLadj_mul, CV_112_1_pre_eq, CV_112_1_pim_eq]

def CV_112_2_pre : Polynomial ℚ := interpQ 8639957931 [3480984158484, 185614872584680, 359374577590193, 598886493151467, 896152541443994, 1065858437089265, 1205848625709314, 1292374421828291, 1224136182279682, 1210356976490865, 1199214247015711, 1192134009937044, 1013599374431031, 850982398900672, 625249689128215, 341165880238340, 179048785827914, 39058597207865, -55056000145957]
def CV_112_2_pim : Polynomial ℚ := interpQ 8639957931 [-130368811005376, -260737622010752, -302163215772183, -367642635758591, -284467955154204, -112410379978899, 14886266663910, 228542102090259, 342446243952690, 340073959920961, 330961018303445, 447594749461726, 564228480620007, 596541132763922, 659648268718601, 582828242597522, 422254071796644, 309721918431045, 107549487379123]
theorem CV_112_2_pre_eq :
    CV_1_re_101 * Fplus_dV_re_011 - CV_1_im_101 * Fplus_dV_im_011 = CV_112_2_pre := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_112_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_2_pim_eq :
    CV_1_re_101 * Fplus_dV_im_011 + CV_1_im_101 * Fplus_dV_re_011 = CV_112_2_pim := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_112_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_2_mul :
    CV_1_c_101 * Fplus_dV_c_011 = ofLadj CV_112_2_pre CV_112_2_pim := by
  rw [CV_1_c_101_def, Fplus_dV_c_011_def, ofLadj_mul, CV_112_2_pre_eq, CV_112_2_pim_eq]

def CV_112_3_pre : Polynomial ℚ := interpQ 8639957931 [-2068690893106, -1086208130465000, -2058327624466928, -3542295805667018, -5780457822494444, -7458832316421602, -9092560846805362, -10409603583626818, -10584797181920880, -10954331820862678, -11235900113329128, -11339282930741484, -10149691982864128, -8896004196395750, -7042501376253862, -4465162499985610, -2584960274382508, -951231743998748, 163983261146764]
def CV_112_3_pim : Polynomial ℚ := interpQ 8639957931 [1002536717284410, 2005073434568820, 2709752694703636, 3805111780849882, 3981588148247760, 3540895255684730, 3103863405351286, 1849423308487774, 948460723211792, 895514683889638, 651089976485308, -709324873880860, -2069739724247028, -3018843691786174, -4167148817254574, -4188910761767350, -3434097251645972, -2624237722582944, -1055677008161084]
theorem CV_112_3_pre_eq :
    CV_1_re_002 * Fplus_dV_re_110 - CV_1_im_002 * Fplus_dV_im_110 = CV_112_3_pre := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_112_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_3_pim_eq :
    CV_1_re_002 * Fplus_dV_im_110 + CV_1_im_002 * Fplus_dV_re_110 = CV_112_3_pim := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_112_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_3_mul :
    CV_1_c_002 * Fplus_dV_c_110 = ofLadj CV_112_3_pre CV_112_3_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_110_def, ofLadj_mul, CV_112_3_pre_eq, CV_112_3_pim_eq]

def CV_112_4_pre : Polynomial ℚ := interpQ 8639957931 [998372324730, -21472258208440, -45797223732428, -78288166273509, -124638485382941, -161220570057746, -189936657425713, -198402980189800, -179281600559768, -165828330937350, -155622048042536, -152797451146886, -134149789834096, -120031107204922, -100993434286259, -67005815914217, -37787957538585, -9071870170618, 6758678892642]
def CV_112_4_pim : Polynomial ℚ := interpQ 8639957931 [23063867427650, 46127734855300, 57139898777934, 72572977253873, 71057446349851, 50180919672702, 21303121033449, -18538888213410, -40504194555118, -38525370259012, -29626624364566, -39699026904048, -49771429443530, -51884847471718, -65339101651551, -69462432412043, -60009351418133, -44745008240814, -16326444677194]
theorem CV_112_4_pre_eq :
    CV_2_re_101 * Fplus_dW_re_011 - CV_2_im_101 * Fplus_dW_im_011 = CV_112_4_pre := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_112_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_4_pim_eq :
    CV_2_re_101 * Fplus_dW_im_011 + CV_2_im_101 * Fplus_dW_re_011 = CV_112_4_pim := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_112_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_4_mul :
    CV_2_c_101 * Fplus_dW_c_011 = ofLadj CV_112_4_pre CV_112_4_pim := by
  rw [CV_2_c_101_def, Fplus_dW_c_011_def, ofLadj_mul, CV_112_4_pre_eq, CV_112_4_pim_eq]

def CV_112_5_pre : Polynomial ℚ := interpQ 8639957931 [-58117182066712, -814023158925280, -1654353907651276, -2721077881001184, -4051710637456888, -4814861843185676, -5429238206914680, -5767038463515204, -5493029773946272, -5388726832831280, -5309815716070322, -5221645194423508, -4495792557145042, -3734372925180004, -2771951892945088, -1536576694457824, -830327855144320, -215951491415316, 178751131600492]
def CV_112_5_pim : Polynomial ℚ := interpQ 8639957931 [548992481882088, 1097984963764176, 1302198013515436, 1534412380106808, 1155398108574992, 402765738619720, -197074462520524, -1083557590807540, -1589462856537676, -1574831854848532, -1505860836837294, -1954180536934944, -2402500237032594, -2537742268772616, -2755325633674844, -2419526233203000, -1755696895063744, -1260370491141164, -462690394670164]
theorem CV_112_5_pre_eq :
    CV_2_re_002 * Fplus_dW_re_110 - CV_2_im_002 * Fplus_dW_im_110 = CV_112_5_pre := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_112_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_5_pim_eq :
    CV_2_re_002 * Fplus_dW_im_110 + CV_2_im_002 * Fplus_dW_re_110 = CV_112_5_pim := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_112_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_112_5_mul :
    CV_2_c_002 * Fplus_dW_c_110 = ofLadj CV_112_5_pre CV_112_5_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_110_def, ofLadj_mul, CV_112_5_pre_eq, CV_112_5_pim_eq]

theorem CV_112_6_mul : CV_3_c_102 = ofLadj CV_3_re_102 CV_3_im_102 := CV_3_c_102_def

@[expose] public def CV_coeff_112 : Ki := CV_0_c_101 * Fplus_dU_c_011 + CV_0_c_002 * Fplus_dU_c_110 + CV_1_c_101 * Fplus_dV_c_011 + CV_1_c_002 * Fplus_dV_c_110 + CV_2_c_101 * Fplus_dW_c_011 + CV_2_c_002 * Fplus_dW_c_110 + CV_3_c_102

theorem CV_coeff_112_sum :
    CV_coeff_112 = ofLadj (CV_112_0_pre + CV_112_1_pre + CV_112_2_pre + CV_112_3_pre + CV_112_4_pre + CV_112_5_pre + CV_3_re_102) (CV_112_0_pim + CV_112_1_pim + CV_112_2_pim + CV_112_3_pim + CV_112_4_pim + CV_112_5_pim + CV_3_im_102) := by
  simp only [CV_coeff_112, CV_112_0_mul, CV_112_1_mul, CV_112_2_mul, CV_112_3_mul, CV_112_4_mul, CV_112_5_mul, CV_112_6_mul]
  simp [ofLadj_add, add_assoc]

def CV_112_qre : Polynomial ℚ := interpQ 8639957931 [-50535430875802, -2246427001354398, -2231508292861405, -3056823304352113, -4595224475671861, -3186534577489934, -2960420718222856, -1929119898223018, 414390833832215]
def CV_112_qim : Polynomial ℚ := interpQ 8639957931 [1986795110289062, 1986795110289062, 1199299562576097, 1796872070785569, -108226377578865, -1551253379364326, -1510876733516196, -3052648701696782, -1906431221438589]
theorem CV_coeff_112_poly_re :
    CV_112_0_pre + CV_112_1_pre + CV_112_2_pre + CV_112_3_pre + CV_112_4_pre + CV_112_5_pre + CV_3_re_102 = (0 : Polynomial ℚ) + Phi11 * CV_112_qre := by
  rw [phi11_interpQ]
  simp only [CV_112_0_pre, CV_112_1_pre, CV_112_2_pre, CV_112_3_pre, CV_112_4_pre, CV_112_5_pre, CV_3_re_102_def, CV_112_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_112_poly_im :
    CV_112_0_pim + CV_112_1_pim + CV_112_2_pim + CV_112_3_pim + CV_112_4_pim + CV_112_5_pim + CV_3_im_102 = (0 : Polynomial ℚ) + Phi11 * CV_112_qim := by
  rw [phi11_interpQ]
  simp only [CV_112_0_pim, CV_112_1_pim, CV_112_2_pim, CV_112_3_pim, CV_112_4_pim, CV_112_5_pim, CV_3_im_102_def, CV_112_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_112_eq :
    CV_coeff_112 = (0 : Ki) := by
  rw [CV_coeff_112_sum, CV_coeff_112_poly_re,
    CV_coeff_112_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
