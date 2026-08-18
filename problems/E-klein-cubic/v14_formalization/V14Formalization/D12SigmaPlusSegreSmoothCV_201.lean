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

def CV_201_0_pre : Polynomial ℚ := interpQ 17279915862 [-1780994847304, -15319354311616, -28209075460672, -44284601104018, -64002512883740, -72805251068614, -80143469724136, -82763959987622, -76791432010640, -75672511678072, -74729321821944, -72719703579364, -59409967510328, -47463436217400, -32506830906622, -13933354618326, -5743160361754, 1595058293768, 4828092485556]
def CV_201_0_pim : Polynomial ℚ := interpQ 17279915862 [7110653687256, 14221307374512, 13057078689712, 14259955101306, 4542225055280, -9808050544864, -20805748440082, -34958268195586, -42194704159390, -41995492970734, -41202629583496, -47205842117576, -53209054651656, -51251962579618, -52255627802556, -43040999443698, -29690885410968, -19885692464726, -6733334276636]
theorem CV_201_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_101 - CV_0_im_100 * Fplus_dU_im_101 = CV_201_0_pre := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_201_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_101 + CV_0_im_100 * Fplus_dU_re_101 = CV_201_0_pim := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_201_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_0_mul :
    CV_0_c_100 * Fplus_dU_c_101 = ofLadj CV_201_0_pre CV_201_0_pim := by
  rw [CV_0_c_100_def, Fplus_dU_c_101_def, ofLadj_mul, CV_201_0_pre_eq, CV_201_0_pim_eq]

def CV_201_1_pre : Polynomial ℚ := interpQ 17279915862 [-130776207994638, 0, 116048676602001, 331493169511368, 1018789380233823, 1710235993132581, 2421762314705445, 3000236012263413, 3218971573441659, 3312807806616348, 3383739413697378, 3541642075953396, 3383739413697378, 3196759130014347, 2887478403930291, 2114617253118453, 1372070762388717, 660544440815853, 133170621088863]
def CV_201_1_pim : Polynomial ℚ := interpQ 17279915862 [-446443090618680, -892886181237360, -1451505333327651, -2209595390349708, -2677448187915819, -2902067756513244, -2961107960997579, -2530609702152732, -2249004386451237, -2235985221933825, -2173934672754678, -1636957998935160, -1099981325115642, -479311623846204, 291797597693265, 720851655130842, 865569258906405, 830804279496738, 320404055830029]
theorem CV_201_1_pre_eq :
    CV_0_re_001 * Fplus_dU_re_200 - CV_0_im_001 * Fplus_dU_im_200 = CV_201_1_pre := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_201_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_1_pim_eq :
    CV_0_re_001 * Fplus_dU_im_200 + CV_0_im_001 * Fplus_dU_re_200 = CV_201_1_pim := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_201_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_1_mul :
    CV_0_c_001 * Fplus_dU_c_200 = ofLadj CV_201_1_pre CV_201_1_pim := by
  rw [CV_0_c_001_def, Fplus_dU_c_200_def, ofLadj_mul, CV_201_1_pre_eq, CV_201_1_pim_eq]

def CV_201_2_pre : Polynomial ℚ := interpQ 17279915862 [5282113594080, 78549228600000, 159258541876536, 262133770674394, 390286636078998, 463055294588816, 522802873389938, 555297857093614, 528997037257716, 518953289305830, 511341891087758, 503127408800952, 432792662487758, 359694747429294, 266863266583322, 147848358284688, 80549279099420, 20801700298298, -17162862729928]
def CV_201_2_pim : Polynomial ℚ := interpQ 17279915862 [-53110867808300, -106221735616600, -125545635666140, -148346277823570, -111257252463930, -39376753099716, 18028807423478, 103580971590070, 152166330538946, 150777267228946, 144162227801572, 187551406314720, 230940584827868, 243649445450034, 265061024297464, 232149267257492, 168783449628008, 121445573061070, 44408090629208]
theorem CV_201_2_pre_eq :
    CV_1_re_100 * Fplus_dV_re_101 - CV_1_im_100 * Fplus_dV_im_101 = CV_201_2_pre := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_201_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_2_pim_eq :
    CV_1_re_100 * Fplus_dV_im_101 + CV_1_im_100 * Fplus_dV_re_101 = CV_201_2_pim := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_201_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_2_mul :
    CV_1_c_100 * Fplus_dV_c_101 = ofLadj CV_201_2_pre CV_201_2_pim := by
  rw [CV_1_c_100_def, Fplus_dV_c_101_def, ofLadj_mul, CV_201_2_pre_eq, CV_201_2_pim_eq]

def CV_201_3_pre : Polynomial ℚ := interpQ 17279915862 [-2760500161816, 311625107162608, 622543529745543, 1015241304477410, 1716855204074760, 2197833622272204, 2650858579438977, 2847776131725380, 2650547216968479, 2509092345900206, 2401808748877529, 2363875754025104, 2090183641714921, 1886548816154663, 1635305912491069, 1062986187957959, 659136274362625, 206111317195852, -67934739692661]
def CV_201_3_pim : Polynomial ℚ := interpQ 17279915862 [-295719619325130, -591439238650260, -764338906295455, -1048665496188099, -1055130083589601, -774411835077115, -464953338539338, 131256125672170, 453620016113434, 433768093197999, 340230124263328, 499249292965636, 658268461667944, 737630160378468, 1002104827355677, 1067335896228830, 907000387797498, 739424133099967, 263597408969613]
theorem CV_201_3_pre_eq :
    CV_1_re_001 * Fplus_dV_re_200 - CV_1_im_001 * Fplus_dV_im_200 = CV_201_3_pre := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_201_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_3_pim_eq :
    CV_1_re_001 * Fplus_dV_im_200 + CV_1_im_001 * Fplus_dV_re_200 = CV_201_3_pim := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_201_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_3_mul :
    CV_1_c_001 * Fplus_dV_c_200 = ofLadj CV_201_3_pre CV_201_3_pim := by
  rw [CV_1_c_001_def, Fplus_dV_c_200_def, ofLadj_mul, CV_201_3_pre_eq, CV_201_3_pim_eq]

def CV_201_4_pre : Polynomial ℚ := interpQ 17279915862 [8279413206204, 141130774971984, 280927294381678, 455104152958192, 692253699749976, 836051469432134, 968283682715182, 1056077729216204, 1038908821442504, 1052968115421482, 1063466019532998, 1059387519703728, 922335244561014, 772040821039804, 583804668484312, 334011042607084, 182563503786242, 50331290503194, -29812986859144]
def CV_201_4_pim : Polynomial ℚ := interpQ 17279915862 [-101228202532012, -202456405064024, -245430983715246, -307672520002148, -267142258362276, -161836387737316, -80125470161448, 66750252450792, 151873033080212, 153766982526940, 162981191256112, 277744738778748, 392508286301384, 444697073681778, 508832559415408, 462525937800800, 345334199288908, 249660731103328, 90899140604156]
theorem CV_201_4_pre_eq :
    CV_2_re_100 * Fplus_dW_re_101 - CV_2_im_100 * Fplus_dW_im_101 = CV_201_4_pre := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_201_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_4_pim_eq :
    CV_2_re_100 * Fplus_dW_im_101 + CV_2_im_100 * Fplus_dW_re_101 = CV_201_4_pim := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_201_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_4_mul :
    CV_2_c_100 * Fplus_dW_c_101 = ofLadj CV_201_4_pre CV_201_4_pim := by
  rw [CV_2_c_100_def, Fplus_dW_c_101_def, ofLadj_mul, CV_201_4_pre_eq, CV_201_4_pim_eq]

def CV_201_5_pre : Polynomial ℚ := interpQ 17279915862 [-72403906417260, -518838974714592, -977887595351772, -1538294549933329, -2190150568772930, -2509793600215389, -2748422174169921, -2858441624987917, -2647858181044378, -2607731695761506, -2577045423687339, -2493229753295642, -2058206448972747, -1629844100409734, -1109563631111049, -494598189635465, -196897346679682, 41731227274850, 173692866579522]
def CV_201_5_pim : Polynomial ℚ := interpQ 17279915862 [232768507025564, 465537014051128, 442760914765636, 441889930995727, 119980750297444, -377198675077980, -758239069181173, -1244236121187008, -1512794668286427, -1507043832554276, -1480485996729896, -1674327492651988, -1868168988574080, -1818835053464208, -1812213233962148, -1507120661520478, -1044097657405002, -703582569588693, -251741938842806]
theorem CV_201_5_pre_eq :
    CV_2_re_001 * Fplus_dW_re_200 - CV_2_im_001 * Fplus_dW_im_200 = CV_201_5_pre := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_201_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_5_pim_eq :
    CV_2_re_001 * Fplus_dW_im_200 + CV_2_im_001 * Fplus_dW_re_200 = CV_201_5_pim := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_201_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_5_mul :
    CV_2_c_001 * Fplus_dW_c_200 = ofLadj CV_201_5_pre CV_201_5_pim := by
  rw [CV_2_c_001_def, Fplus_dW_c_200_def, ofLadj_mul, CV_201_5_pre_eq, CV_201_5_pim_eq]

def CV_201_6_pre : Polynomial ℚ := interpQ 17279915862 [658108698940, 0, -1836022117908, -4193708368960, -6381808508900, -7675513050920, -7675513050920, -6381808508900, -4193708368960, -1836022117908]
def CV_201_6_pim : Polynomial ℚ := interpQ 17279915862 [2318759469864, 4637518939728, 6175070181836, 6552895522324, 5503955778056, 3550949498328, 1086569441400, -866436838328, -1915376582596, -1537551242108]
theorem CV_201_6_neg_re : -CV_3_re_201 = CV_201_6_pre := by
  simp only [CV_3_re_201_def, CV_201_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_6_neg_im : -CV_3_im_201 = CV_201_6_pim := by
  simp only [CV_3_im_201_def, CV_201_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_201_6_mul : -CV_3_c_201 = ofLadj CV_201_6_pre CV_201_6_pim := by
  rw [CV_3_c_201_def, ofLadj_neg, CV_201_6_neg_re, CV_201_6_neg_im]

@[expose] public def CV_coeff_201 : Ki := CV_0_c_100 * Fplus_dU_c_101 + CV_0_c_001 * Fplus_dU_c_200 + CV_1_c_100 * Fplus_dV_c_101 + CV_1_c_001 * Fplus_dV_c_200 + CV_2_c_100 * Fplus_dW_c_101 + CV_2_c_001 * Fplus_dW_c_200 + (-CV_3_c_201)

theorem CV_coeff_201_sum :
    CV_coeff_201 = ofLadj (CV_201_0_pre + CV_201_1_pre + CV_201_2_pre + CV_201_3_pre + CV_201_4_pre + CV_201_5_pre + CV_201_6_pre) (CV_201_0_pim + CV_201_1_pim + CV_201_2_pim + CV_201_3_pim + CV_201_4_pim + CV_201_5_pim + CV_201_6_pim) := by
  simp only [CV_coeff_201, CV_201_0_mul, CV_201_1_mul, CV_201_2_mul, CV_201_3_mul, CV_201_4_mul, CV_201_5_mul, CV_201_6_mul]
  simp [ofLadj_add, add_assoc]

def CV_201_qre : Polynomial ℚ := interpQ 17279915862 [-193501973921794, 190648755630178, 173698567967022, 306354188539651, 1080450491756930, 1059251985118825, 1110564278213753, 784334043509607, 196780990872208]
def CV_201_qim : Polynomial ℚ := interpQ 17279915862 [-654303860101438, -654303860101438, -816220075164432, -1126749107376860, -729373948456678, -280197657351061, -4967701902835, 757033031794120, 460833422913564]
theorem CV_coeff_201_poly_re :
    CV_201_0_pre + CV_201_1_pre + CV_201_2_pre + CV_201_3_pre + CV_201_4_pre + CV_201_5_pre + CV_201_6_pre = (0 : Polynomial ℚ) + Phi11 * CV_201_qre := by
  rw [phi11_interpQ]
  simp only [CV_201_0_pre, CV_201_1_pre, CV_201_2_pre, CV_201_3_pre, CV_201_4_pre, CV_201_5_pre, CV_201_6_pre, CV_201_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_201_poly_im :
    CV_201_0_pim + CV_201_1_pim + CV_201_2_pim + CV_201_3_pim + CV_201_4_pim + CV_201_5_pim + CV_201_6_pim = (0 : Polynomial ℚ) + Phi11 * CV_201_qim := by
  rw [phi11_interpQ]
  simp only [CV_201_0_pim, CV_201_1_pim, CV_201_2_pim, CV_201_3_pim, CV_201_4_pim, CV_201_5_pim, CV_201_6_pim, CV_201_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_201_eq :
    CV_coeff_201 = (0 : Ki) := by
  rw [CV_coeff_201_sum, CV_coeff_201_poly_re,
    CV_coeff_201_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
