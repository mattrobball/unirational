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

def CV_202_0_pre : Polynomial ℚ := interpQ 8639957931 [-407814850576, -9779161781248, -17864798326244, -28464303351268, -40910835278600, -46808412458675, -50773005270475, -53618603807863, -48381315063333, -48241177472844, -46876373667702, -47080463253864, -37097211886454, -30376379146600, -19917011712065, -8628566727211, -2901223114807, 1063369696993, 4079201802052]
def CV_202_0_pim : Polynomial ℚ := interpQ 8639957931 [5025169397792, 10050338795584, 9118418148636, 10144777030432, 3801876491480, -5742534623197, -12027104438675, -21744147034106, -26557613103243, -25888826705421, -25734446854170, -29883833690592, -34033220527014, -32946920028815, -33304492512789, -28022344591470, -18302105821301, -13645583702427, -3752713451504]
theorem CV_202_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_101 - CV_0_im_101 * Fplus_dU_im_101 = CV_202_0_pre := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_202_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_101 + CV_0_im_101 * Fplus_dU_re_101 = CV_202_0_pim := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_202_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_0_mul :
    CV_0_c_101 * Fplus_dU_c_101 = ofLadj CV_202_0_pre CV_202_0_pim := by
  rw [CV_0_c_101_def, Fplus_dU_c_101_def, ofLadj_mul, CV_202_0_pre_eq, CV_202_0_pim_eq]

def CV_202_1_pre : Polynomial ℚ := interpQ 8639957931 [94514823452898, 0, -83500818597450, -238951896713361, -735107342800140, -1234346272932648, -1747998076344585, -2165507547806424, -2323414776336939, -2390967776185830, -2442366601320918, -2556216233544816, -2442366601320918, -2307466957588380, -2084462879623578, -1526400086261772, -990292600502520, -476640797090583, -95999881255488]
def CV_202_1_pim : Polynomial ℚ := interpQ 8639957931 [322367461561530, 644734923123060, 1048075022086434, 1595180100456315, 1933251458139180, 2094968132564310, 2137935622268130, 1827101161269897, 1624043180936985, 1614436174679193, 1569764619428283, 1182014025725610, 794263432022937, 346251777808653, -210460306819020, -520311871645953, -624594050812779, -599546729445381, -231277773188844]
theorem CV_202_1_pre_eq :
    CV_0_re_002 * Fplus_dU_re_200 - CV_0_im_002 * Fplus_dU_im_200 = CV_202_1_pre := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_202_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_1_pim_eq :
    CV_0_re_002 * Fplus_dU_im_200 + CV_0_im_002 * Fplus_dU_re_200 = CV_202_1_pim := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_202_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_1_mul :
    CV_0_c_002 * Fplus_dU_c_200 = ofLadj CV_202_1_pre CV_202_1_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_200_def, ofLadj_mul, CV_202_1_pre_eq, CV_202_1_pim_eq]

def CV_202_2_pre : Polynomial ℚ := interpQ 8639957931 [-1423556249827, -66291025923100, -131704627445274, -220103323327803, -328608778427453, -389860166283929, -439828125301370, -467641889427288, -443491413487661, -434332016885465, -428544615404161, -423873467270907, -362253589481061, -302627389440191, -223388090159858, -122274954578282, -65906278681732, -15938319664291, 16758156421553]
def CV_202_2_pim : Polynomial ℚ := interpQ 8639957931 [46086782316755, 92173564633510, 108306199139582, 128896308957595, 98362879524081, 35061942170846, -10162138154175, -86057904159663, -124819858676690, -124134816537280, -118151852115219, -156067209040725, -193982565966231, -204132236050242, -224037303728845, -196414986426561, -141141554580514, -103719102884097, -35850842385797]
theorem CV_202_2_pre_eq :
    CV_1_re_101 * Fplus_dV_re_101 - CV_1_im_101 * Fplus_dV_im_101 = CV_202_2_pre := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_202_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_2_pim_eq :
    CV_1_re_101 * Fplus_dV_im_101 + CV_1_im_101 * Fplus_dV_re_101 = CV_202_2_pim := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_202_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_2_mul :
    CV_1_c_101 * Fplus_dV_c_101 = ofLadj CV_202_2_pre CV_202_2_pim := by
  rw [CV_1_c_101_def, Fplus_dV_c_101_def, ofLadj_mul, CV_202_2_pre_eq, CV_202_2_pim_eq]

def CV_202_3_pre : Polynomial ℚ := interpQ 8639957931 [1171457949162, -217241626093000, -434737575465915, -708151078505112, -1196944543842430, -1532405731774157, -1847857518461492, -1985309617800229, -1848062921011864, -1750008916576391, -1674723510112177, -1648192443119650, -1457481884019177, -1315271341110476, -1139911842506752, -741553255134168, -459671191427884, -144219404740549, 46811818823631]
def CV_202_3_pim : Polynomial ℚ := interpQ 8639957931 [205938384109207, 411876768218414, 532530197514588, 730454054003021, 734519668032918, 539637767611520, 322972180944253, -91246447552271, -316796800067926, -302487815995910, -237606223108490, -348244519564522, -458882816020554, -514654652429308, -698269524845725, -743830008393334, -632169068461883, -515053151004520, -184055482997943]
theorem CV_202_3_pre_eq :
    CV_1_re_002 * Fplus_dV_re_200 - CV_1_im_002 * Fplus_dV_im_200 = CV_202_3_pre := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_202_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_3_pim_eq :
    CV_1_re_002 * Fplus_dV_im_200 + CV_1_im_002 * Fplus_dV_re_200 = CV_202_3_pim := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_202_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_3_mul :
    CV_1_c_002 * Fplus_dV_c_200 = ofLadj CV_202_3_pre CV_202_3_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_200_def, ofLadj_mul, CV_202_3_pre_eq, CV_202_3_pim_eq]

def CV_202_4_pre : Polynomial ℚ := interpQ 8639957931 [-8927485918990, -150305807459080, -299832169196496, -487005295305843, -739991427393875, -894113186216787, -1035473633274372, -1129428527739442, -1110443927673632, -1125353674549513, -1136766164546663, -1132084016418598, -986460357087583, -825521505353017, -623438632367789, -356767340639121, -194532520279596, -53172073222011, 32669759706446]
def CV_202_4_pim : Polynomial ℚ := interpQ 8639957931 [107766426472450, 215532852944900, 262381955925058, 327966993254921, 284639272197951, 171567505047977, 84159018034361, -74045438422092, -165130209637097, -167283531802159, -177127584638629, -299365446536776, -421603308434923, -478296464251551, -546034823746476, -496395023219729, -370704844403069, -268219718807921, -97396850684782]
theorem CV_202_4_pre_eq :
    CV_2_re_101 * Fplus_dW_re_101 - CV_2_im_101 * Fplus_dW_im_101 = CV_202_4_pre := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_202_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_4_pim_eq :
    CV_2_re_101 * Fplus_dW_im_101 + CV_2_im_101 * Fplus_dW_re_101 = CV_202_4_pim := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_202_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_4_mul :
    CV_2_c_101 * Fplus_dW_c_101 = ofLadj CV_202_4_pre CV_202_4_pim := by
  rw [CV_2_c_101_def, Fplus_dW_c_101_def, ofLadj_mul, CV_202_4_pre_eq, CV_202_4_pim_eq]

def CV_202_5_pre : Polynomial ℚ := interpQ 8639957931 [45055163976376, 325609263570112, 613522373769356, 965205827676626, 1374408078613328, 1575315225321261, 1724456377491540, 1794001294455424, 1661197471611477, 1636306679708091, 1616680383089669, 1564867153286840, 1291071119519557, 1022784305938735, 695991643934851, 310182170507772, 122925476389522, -26215675780757, -109411045334324]
def CV_202_5_pim : Polynomial ℚ := interpQ 8639957931 [-146334908449560, -292669816899120, -278221510690860, -277984963179638, -76112626403112, 236314849659623, 475179564849330, 780306977174986, 948863490068460, 944961005882066, 928457676808714, 1050299857219320, 1172142037629926, 1141190402348314, 1137051370650698, 946113895815038, 654706151168956, 441729331861611, 157621650952608]
theorem CV_202_5_pre_eq :
    CV_2_re_002 * Fplus_dW_re_200 - CV_2_im_002 * Fplus_dW_im_200 = CV_202_5_pre := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_202_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_5_pim_eq :
    CV_2_re_002 * Fplus_dW_im_200 + CV_2_im_002 * Fplus_dW_re_200 = CV_202_5_pim := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_202_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_202_5_mul :
    CV_2_c_002 * Fplus_dW_c_200 = ofLadj CV_202_5_pre CV_202_5_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_200_def, ofLadj_mul, CV_202_5_pre_eq, CV_202_5_pim_eq]

@[expose] public def CV_coeff_202 : Ki := CV_0_c_101 * Fplus_dU_c_101 + CV_0_c_002 * Fplus_dU_c_200 + CV_1_c_101 * Fplus_dV_c_101 + CV_1_c_002 * Fplus_dV_c_200 + CV_2_c_101 * Fplus_dW_c_101 + CV_2_c_002 * Fplus_dW_c_200

theorem CV_coeff_202_sum :
    CV_coeff_202 = ofLadj (CV_202_0_pre + CV_202_1_pre + CV_202_2_pre + CV_202_3_pre + CV_202_4_pre + CV_202_5_pre) (CV_202_0_pim + CV_202_1_pim + CV_202_2_pim + CV_202_3_pim + CV_202_4_pim + CV_202_5_pim) := by
  simp only [CV_coeff_202, CV_202_0_mul, CV_202_1_mul, CV_202_2_mul, CV_202_3_mul, CV_202_4_mul, CV_202_5_mul]
  simpa [add_assoc] using ofLadj_add6 CV_202_0_pre CV_202_0_pim CV_202_1_pre CV_202_1_pim CV_202_2_pre CV_202_2_pim CV_202_3_pre CV_202_3_pim CV_202_4_pre CV_202_4_pim CV_202_5_pre CV_202_5_pim

def CV_202_qre : Polynomial ℚ := interpQ 8639957931 [129982588359043, -247990946045359, -236109257575707, -363352454264738, -949684779602409, -855063695215765, -875255436815819, -610030910965068, -105091989836130]
def CV_202_qim : Polynomial ℚ := interpQ 8639957931 [540849315408174, 540849315408174, 600491651307090, 832466988399208, 463805257459852, 93345134448581, -73750518927855, -663742942226473, -394712011756262]
theorem CV_coeff_202_poly_re :
    CV_202_0_pre + CV_202_1_pre + CV_202_2_pre + CV_202_3_pre + CV_202_4_pre + CV_202_5_pre = (0 : Polynomial ℚ) + Phi11 * CV_202_qre := by
  rw [phi11_interpQ]
  simp only [CV_202_0_pre, CV_202_1_pre, CV_202_2_pre, CV_202_3_pre, CV_202_4_pre, CV_202_5_pre, CV_202_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_202_poly_im :
    CV_202_0_pim + CV_202_1_pim + CV_202_2_pim + CV_202_3_pim + CV_202_4_pim + CV_202_5_pim = (0 : Polynomial ℚ) + Phi11 * CV_202_qim := by
  rw [phi11_interpQ]
  simp only [CV_202_0_pim, CV_202_1_pim, CV_202_2_pim, CV_202_3_pim, CV_202_4_pim, CV_202_5_pim, CV_202_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_202_eq :
    CV_coeff_202 = (0 : Ki) := by
  rw [CV_coeff_202_sum, CV_coeff_202_poly_re,
    CV_coeff_202_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
