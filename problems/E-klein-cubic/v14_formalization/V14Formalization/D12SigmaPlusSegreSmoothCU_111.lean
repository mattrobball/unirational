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

def CU_111_0_pre : Polynomial ℚ := interpQ 235794999 [73207338476048, 523155747958016, 986254429705528, 1550629459356920, 2207693164743352, 2530935542376400, 2770274147137448, 2881890283126988, 2669797699676996, 2629308542388008, 2598434932277308, 2513711945717784, 2075279184319292, 1643054112682480, 1119168240320076, 499288387720876, 198132449009104, -41206155751944, -174908730662760]
def CU_111_0_pim : Polynomial ℚ := interpQ 235794999 [-234571137826560, -469142275653120, -446170642154792, -444680421531100, -121365830685200, 380677348693504, 764880113363744, 1253956836859256, 1525199980741552, 1519367174522356, 1492586090747528, 1687944073364192, 1883302055980856, 1833549338707700, 1826226311864812, 1519920967686784, 1052258948020588, 708929460997428, 254233897214424]
theorem CU_111_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_101 - CU_0_im_010 * Fplus_dU_im_101 = CU_111_0_pre := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_111_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_101 + CU_0_im_010 * Fplus_dU_re_101 = CU_111_0_pim := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_111_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_0_mul :
    CU_0_c_010 * Fplus_dU_c_101 = ofLadj CU_111_0_pre CU_111_0_pim := by
  rw [CU_0_c_010_def, Fplus_dU_c_101_def, ofLadj_mul, CU_111_0_pre_eq, CU_111_0_pim_eq]

def CU_111_1_pre : Polynomial ℚ := interpQ 235794999 [-4349048896400, 636526446302272, 1272899942570460, 2074907644792412, 3507395806780676, 4489938043681280, 5415279598326628, 5817773426019360, 5415030336939984, 5127002834677992, 4907069895299388, 4829505877508552, 4270543448997116, 3854102892107532, 3340122692147572, 2172359011474168, 1347090142942596, 421748588297248, -138018607764516]
def CU_111_1_pim : Polynomial ℚ := interpQ 235794999 [-603669400649336, -1207338801298672, -1560925176498592, -2141186047086872, -2153243277871020, -1581551832474964, -947871165039748, 268186573634548, 928042910930432, 886644079145108, 696039733253192, 1020537168773296, 1345034604293400, 1508016633601404, 2046878672404360, 2179815290689584, 1852964313826212, 1510194219936420, 538976949794808]
theorem CU_111_1_pre_eq :
    CU_0_re_001 * Fplus_dU_re_110 - CU_0_im_001 * Fplus_dU_im_110 = CU_111_1_pre := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_111_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_1_pim_eq :
    CU_0_re_001 * Fplus_dU_im_110 + CU_0_im_001 * Fplus_dU_re_110 = CU_111_1_pim := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_111_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_1_mul :
    CU_0_c_001 * Fplus_dU_c_110 = ofLadj CU_111_1_pre CU_111_1_pim := by
  rw [CU_0_c_001_def, Fplus_dU_c_110_def, ofLadj_mul, CU_111_1_pre_eq, CU_111_1_pim_eq]

def CU_111_2_pre : Polynomial ℚ := interpQ 235794999 [-40695788941004, -553069849643120, -1125084253712568, -1847988373484204, -2751821685793456, -3270672368075540, -3687222469470260, -3916829196667032, -3731944809516660, -3661359240641904, -3607544516275672, -3546831932821020, -3054474666632552, -2536274986929336, -1883956436032456, -1044957520588340, -564558187477308, -148008086082588, 120049990285236]
def CU_111_2_pim : Polynomial ℚ := interpQ 235794999 [372496773731612, 744993547463224, 883264516171736, 1040435434703380, 783696625792896, 273043710569120, -135521933256424, -735173034191732, -1079864855330752, -1069699154107472, -1022979115220412, -1327157032317676, -1631334949414940, -1722885879236392, -1869891096544756, -1642813580592552, -1192115457705708, -854726836779116, -315030528180740]
theorem CU_111_2_pre_eq :
    CU_1_re_010 * Fplus_dV_re_101 - CU_1_im_010 * Fplus_dV_im_101 = CU_111_2_pre := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_111_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_2_pim_eq :
    CU_1_re_010 * Fplus_dV_im_101 + CU_1_im_010 * Fplus_dV_re_101 = CU_111_2_pim := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_111_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_2_mul :
    CU_1_c_010 * Fplus_dV_c_101 = ofLadj CU_111_2_pre CU_111_2_pim := by
  rw [CU_1_c_010_def, Fplus_dV_c_101_def, ofLadj_mul, CU_111_2_pre_eq, CU_111_2_pim_eq]

def CU_111_3_pre : Polynomial ℚ := interpQ 235794999 [427082047620, 1086589990581120, 2057182737717460, 3542754300636868, 5781553040197524, 7460355599381752, 9094630647210756, 10412579562918744, 10586758885102024, 10956226590008408, 11238368311348548, 11343056061164868, 10151778320767428, 8899043852290948, 7044004584465156, 4465626123650836, 2585035660687096, 950760612858092, -165400399070384]
def CU_111_3_pim : Polynomial ℚ := interpQ 235794999 [-1003372202463852, -2006744404927704, -2711199153436612, -3807921439385432, -3984543885884856, -3543037203567956, -3107185637001640, -1850541518598536, -950157314060400, -897054995917716, -652575010641996, 708947324928876, 2070469660499748, 3019404394284376, 4169228998375880, 4190805238164792, 3435227237706240, 2626145847793404, 1055430411248648]
theorem CU_111_3_pre_eq :
    CU_1_re_001 * Fplus_dV_re_110 - CU_1_im_001 * Fplus_dV_im_110 = CU_111_3_pre := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_111_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_3_pim_eq :
    CU_1_re_001 * Fplus_dV_im_110 + CU_1_im_001 * Fplus_dV_re_110 = CU_111_3_pim := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_111_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_3_mul :
    CU_1_c_001 * Fplus_dV_c_110 = ofLadj CU_111_3_pre CU_111_3_pim := by
  rw [CU_1_c_001_def, Fplus_dV_c_110_def, ofLadj_mul, CU_111_3_pre_eq, CU_111_3_pim_eq]

def CU_111_4_pre : Polynomial ℚ := interpQ 235794999 [-24037211052820, -380672528548144, -760991664209060, -1237800633114560, -1878854268366512, -2270907510722368, -2630338673072088, -2868577041989468, -2819547599740028, -2857475423193900, -2886374578980632, -2873029724185208, -2505702050432488, -2096483758984840, -1581746966625468, -905849954047484, -493197178574828, -133766016225108, 83872819575472]
def CU_111_4_pim : Polynomial ℚ := interpQ 235794999 [272380078932748, 544760157865496, 665970439916420, 830590085820156, 719841182383436, 433067605595916, 209831872143796, -192812217219148, -424571249356612, -430033078074776, -455169646410224, -764207157780664, -1073244669151104, -1219591519537476, -1389672994159376, -1262973634457472, -943972891382616, -682580744052928, -247709488402648]
theorem CU_111_4_pre_eq :
    CU_2_re_010 * Fplus_dW_re_101 - CU_2_im_010 * Fplus_dW_im_101 = CU_111_4_pre := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_111_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_4_pim_eq :
    CU_2_re_010 * Fplus_dW_im_101 + CU_2_im_010 * Fplus_dW_re_101 = CU_111_4_pim := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_111_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_4_mul :
    CU_2_c_010 * Fplus_dW_c_101 = ofLadj CU_111_4_pre CU_111_4_pim := by
  rw [CU_2_c_010_def, Fplus_dW_c_101_def, ofLadj_mul, CU_111_4_pre_eq, CU_111_4_pim_eq]

def CU_111_5_pre : Polynomial ℚ := interpQ 235794999 [42538977005640, 575176411539360, 1170254486104224, 1924148225314672, 2864222102888600, 3403445247293244, 3838457956262420, 4076819656584188, 3883735264605920, 3810345863212944, 3754255406219504, 3690772296601072, 3179078994680144, 2640091377108720, 1959587039291248, 1086979386968828, 587916799966328, 152904090997152, -125618166726760]
def CU_111_5_pim : Polynomial ℚ := interpQ 235794999 [-387295482706616, -774590965413232, -919437123938192, -1082836846086608, -813981269428440, -283565804013204, 141970305345948, 767473420148732, 1125949311691832, 1115409389084328, 1066871857768764, 1382951022188288, 1699030186607812, 1795338813817208, 1948198613358120, 1710116774567300, 1242099696317832, 890806881312768, 327702153675752]
theorem CU_111_5_pre_eq :
    CU_2_re_001 * Fplus_dW_re_110 - CU_2_im_001 * Fplus_dW_im_110 = CU_111_5_pre := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_111_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_5_pim_eq :
    CU_2_re_001 * Fplus_dW_im_110 + CU_2_im_001 * Fplus_dW_re_110 = CU_111_5_pim := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_111_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_5_mul :
    CU_2_c_001 * Fplus_dW_c_110 = ofLadj CU_111_5_pre CU_111_5_pim := by
  rw [CU_2_c_001_def, Fplus_dW_c_110_def, ofLadj_mul, CU_111_5_pre_eq, CU_111_5_pim_eq]

def CU_111_6_pre : Polynomial ℚ := interpQ 235794999 [-693690998836, 0, 1888016986548, 4352513119724, 6624202410408, 7967524329556, 7967524329556, 6624202410408, 4352513119724, 1888016986548]
def CU_111_6_pim : Polynomial ℚ := interpQ 235794999 [-2389077998620, -4778155997240, -6415244167336, -6766576349036, -5734013683764, -3630742281372, -1147413715868, 955857686524, 1988420351796, 1637088170096]
theorem CU_111_6_neg_re : -CU_3_re_111 = CU_111_6_pre := by
  simp only [CU_3_re_111_def, CU_111_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_6_neg_im : -CU_3_im_111 = CU_111_6_pim := by
  simp only [CU_3_im_111_def, CU_111_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_111_6_mul : -CU_3_c_111 = ofLadj CU_111_6_pre CU_111_6_pim := by
  rw [CU_3_c_111_def, ofLadj_neg, CU_111_6_neg_re, CU_111_6_neg_im]

theorem CU_111_7_mul : CU_3_c_011 = ofLadj CU_3_re_011 CU_3_im_011 := CU_3_c_011_def

@[expose] public def CU_coeff_111 : Ki := CU_0_c_010 * Fplus_dU_c_101 + CU_0_c_001 * Fplus_dU_c_110 + CU_1_c_010 * Fplus_dV_c_101 + CU_1_c_001 * Fplus_dV_c_110 + CU_2_c_010 * Fplus_dW_c_101 + CU_2_c_001 * Fplus_dW_c_110 + (-CU_3_c_111) + CU_3_c_011

theorem CU_coeff_111_sum :
    CU_coeff_111 = ofLadj (CU_111_0_pre + CU_111_1_pre + CU_111_2_pre + CU_111_3_pre + CU_111_4_pre + CU_111_5_pre + CU_111_6_pre + CU_3_re_011) (CU_111_0_pim + CU_111_1_pim + CU_111_2_pim + CU_111_3_pim + CU_111_4_pim + CU_111_5_pim + CU_111_6_pim + CU_3_im_011) := by
  simp only [CU_coeff_111, CU_111_0_mul, CU_111_1_mul, CU_111_2_mul, CU_111_3_mul, CU_111_4_mul, CU_111_5_mul, CU_111_6_mul, CU_111_7_mul]
  simp [ofLadj_add, add_assoc]

def CU_111_qre : Polynomial ℚ := interpQ 235794999 [47024925902396, 1840681292287108, 1712969743423436, 2406354334709376, 3723733718387244, 2613025748625896, 2457986652460136, 1602456128456564, -400023094363712]
def CU_111_qim : Polynomial ℚ := interpQ 235794999 [-1584241489659460, -1584241489659460, -920574892821048, -1517136723662220, 36097449240604, 1248409209275888, 1247693017574572, 2585165433857732, 1613603395350244]
theorem CU_coeff_111_poly_re :
    CU_111_0_pre + CU_111_1_pre + CU_111_2_pre + CU_111_3_pre + CU_111_4_pre + CU_111_5_pre + CU_111_6_pre + CU_3_re_011 = (0 : Polynomial ℚ) + Phi11 * CU_111_qre := by
  rw [phi11_interpQ]
  simp only [CU_111_0_pre, CU_111_1_pre, CU_111_2_pre, CU_111_3_pre, CU_111_4_pre, CU_111_5_pre, CU_111_6_pre, CU_3_re_011_def, CU_111_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_111_poly_im :
    CU_111_0_pim + CU_111_1_pim + CU_111_2_pim + CU_111_3_pim + CU_111_4_pim + CU_111_5_pim + CU_111_6_pim + CU_3_im_011 = (0 : Polynomial ℚ) + Phi11 * CU_111_qim := by
  rw [phi11_interpQ]
  simp only [CU_111_0_pim, CU_111_1_pim, CU_111_2_pim, CU_111_3_pim, CU_111_4_pim, CU_111_5_pim, CU_111_6_pim, CU_3_im_011_def, CU_111_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_111_eq :
    CU_coeff_111 = (0 : Ki) := by
  rw [CU_coeff_111_sum, CU_coeff_111_poly_re,
    CU_coeff_111_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
