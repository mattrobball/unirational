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

def CU_021_0_pre : Polynomial ℚ := interpQ 235794999 [-48322974209968, -653944684947520, -1330568871771856, -2185947207677984, -3254632618827432, -3868269789703940, -4361155465401532, -4632683263299020, -4413811622779336, -4330359567346652, -4266681744846736, -4194660522188176, -3612737059899216, -2999790695574796, -2227864415101352, -1235858549009348, -667737023019656, -174851347322064, 142192095462240]
def CU_021_0_pim : Polynomial ℚ := interpQ 235794999 [440351476396392, 880702952792784, 1044644747265536, 1230174877071312, 926262281845544, 322454654576180, -160880877375868, -870431224074516, -1278144009571424, -1266138372164476, -1210906080110392, -1570425726623536, -1929945373136680, -2038654875555348, -2212179367954176, -1943311147497820, -1410418447987224, -1011303829667376, -372668410727496]
theorem CU_021_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_011 - CU_0_im_010 * Fplus_dU_im_011 = CU_021_0_pre := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_021_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_011 + CU_0_im_010 * Fplus_dU_re_011 = CU_021_0_pim := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_021_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_0_mul :
    CU_0_c_010 * Fplus_dU_c_011 = ofLadj CU_021_0_pre CU_021_0_pim := by
  rw [CU_0_c_010_def, Fplus_dU_c_011_def, ofLadj_mul, CU_021_0_pre_eq, CU_021_0_pim_eq]

def CU_021_1_pre : Polynomial ℚ := interpQ 235794999 [402283896356, 795658057877840, 1506483462037818, 2594844621769234, 4234179871759898, 5463526857810620, 6660843801450766, 7625916613161588, 7753294706268948, 8023961364602068, 8230565570168786, 8307064796433808, 7434907512290946, 6517477902564250, 5158450084499714, 3270374283837342, 1893332977444878, 696016033804732, -121362457564348]
def CU_021_1_pim : Polynomial ℚ := interpQ 235794999 [-734695299364724, -1469390598729448, -1985570065508302, -2788594472337666, -2917576298802830, -2594574026399556, -2275271928981878, -1354543604850096, -695202701853584, -656283026748876, -477144872377190, 519796305982672, 1516737484342534, 2212055105493074, 3053999187427146, 3069351706140822, 2516297907311162, 1923750061306168, 772970210748000]
theorem CU_021_1_pre_eq :
    CU_0_re_001 * Fplus_dU_re_020 - CU_0_im_001 * Fplus_dU_im_020 = CU_021_1_pre := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_021_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_1_pim_eq :
    CU_0_re_001 * Fplus_dU_im_020 + CU_0_im_001 * Fplus_dU_re_020 = CU_021_1_pim := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_021_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_1_mul :
    CU_0_c_001 * Fplus_dU_c_020 = ofLadj CU_021_1_pre CU_021_1_pim := by
  rw [CU_0_c_001_def, Fplus_dU_c_020_def, ofLadj_mul, CU_021_1_pre_eq, CU_021_1_pim_eq]

def CU_021_2_pre : Polynomial ℚ := interpQ 235794999 [110695819919152, 1548595579000736, 3072086654116244, 5031482165496236, 7505447811960248, 8940606672456092, 10110973419331348, 10816253606497232, 10308364836552900, 10191755307506216, 10102901081127096, 9959269835073416, 8554305502126360, 7119668653389972, 5276882671056664, 2910029488975380, 1538257358776196, 367890611900940, -400776305561604]
def CU_021_2_pim : Polynomial ℚ := interpQ 235794999 [-1054052363441376, -2108104726882752, -2471248436621116, -2967606176654956, -2279348859147392, -879801240452732, 258275765668220, 1960191352830680, 2957268095223460, 2940471764269728, 2863223774035416, 3804530866432392, 4745837958829368, 5031733678333420, 5511295087413528, 4872070636931804, 3571583408508764, 2550899072257780, 948043875366940]
theorem CU_021_2_pre_eq :
    CU_1_re_010 * Fplus_dV_re_011 - CU_1_im_010 * Fplus_dV_im_011 = CU_021_2_pre := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_021_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_2_pim_eq :
    CU_1_re_010 * Fplus_dV_im_011 + CU_1_im_010 * Fplus_dV_re_011 = CU_021_2_pim := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_021_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_2_mul :
    CU_1_c_010 * Fplus_dV_c_011 = ofLadj CU_021_2_pre CU_021_2_pim := by
  rw [CU_1_c_010_def, Fplus_dV_c_011_def, ofLadj_mul, CU_021_2_pre_eq, CU_021_2_pim_eq]

def CU_021_3_pre : Polynomial ℚ := interpQ 235794999 [-67263646023288, -651953994348672, -1135055985273240, -1833154719388710, -2769650932194186, -3148869679788654, -3611827193487990, -4145177822575614, -4244416572041712, -4575881066858112, -4828931792636688, -4855989445345104, -4176977798288016, -3440825081584872, -2411261852653002, -1170168051306456, -609938262841020, -146980749141684, 205358839074972]
def CU_021_3_pim : Polynomial ℚ := interpQ 235794999 [373839423456276, 747678846912552, 861196963333260, 1117227642147762, 839977196781990, 378664295715618, 255032211899646, -214396114092174, -571613872547112, -619278488750292, -838578745375092, -1533690185350068, -2228801625325044, -2561619998370552, -2865315293388234, -2448939699746196, -1705929328139976, -1247468703262872, -496342906731204]
theorem CU_021_3_pre_eq :
    CU_1_re_001 * Fplus_dV_re_020 - CU_1_im_001 * Fplus_dV_im_020 = CU_021_3_pre := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_021_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_3_pim_eq :
    CU_1_re_001 * Fplus_dV_im_020 + CU_1_im_001 * Fplus_dV_re_020 = CU_021_3_pim := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_021_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_3_mul :
    CU_1_c_001 * Fplus_dV_c_020 = ofLadj CU_021_3_pre CU_021_3_pim := by
  rw [CU_1_c_001_def, Fplus_dV_c_020_def, ofLadj_mul, CU_021_3_pre_eq, CU_021_3_pim_eq]

def CU_021_4_pre : Polynomial ℚ := interpQ 235794999 [2211423903900, -54381789792592, -116261053766244, -199056404625756, -316564399995748, -409396872100008, -482425231489988, -504142119290284, -455370845299952, -421066680656600, -395081096968068, -387751069040472, -340699307175476, -304805626890356, -256314440674196, -170253868735400, -95865648781240, -22837289391260, 17323850559136]
def CU_021_4_pim : Polynomial ℚ := interpQ 235794999 [58333507630604, 116667015261208, 145079693339076, 183909763386436, 179896132911508, 126924774634752, 53667745919100, -47762955963172, -103774689212608, -98800208430312, -76032696125780, -101403623998296, -126774551870812, -132419717644148, -166275306909212, -176759625514928, -152860535303872, -113872217985364, -41513784168792]
theorem CU_021_4_pre_eq :
    CU_2_re_010 * Fplus_dW_re_011 - CU_2_im_010 * Fplus_dW_im_011 = CU_021_4_pre := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_021_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_4_pim_eq :
    CU_2_re_010 * Fplus_dW_im_011 + CU_2_im_010 * Fplus_dW_re_011 = CU_021_4_pim := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_021_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_4_mul :
    CU_2_c_010 * Fplus_dW_c_011 = ofLadj CU_021_4_pre CU_021_4_pim := by
  rw [CU_2_c_010_def, Fplus_dW_c_011_def, ofLadj_mul, CU_021_4_pre_eq, CU_021_4_pim_eq]

def CU_021_5_pre : Polynomial ℚ := interpQ 235794999 [-57866982376576, -805246976155104, -1597714793949412, -2619534376003276, -3906004925414152, -4651699009692736, -5262958097301836, -5629051468483486, -5363794461603048, -5303215099904296, -5256906455459126, -5181697311084016, -4451659479304022, -3705500305954884, -2744260085599772, -1513470170817794, -800975967073780, -189716879464680, 209576372251540]
def CU_021_5_pim : Polynomial ℚ := interpQ 235794999 [547965439904656, 1095930879809312, 1286269751489572, 1544265092486228, 1183758195210904, 457090084111504, -135589043454724, -1023302157146214, -1541744369065916, -1533041572263684, -1493005871719786, -1982145543986752, -2471285216253718, -2621588387390080, -2870880931584504, -2535767969821718, -1860591651368004, -1329269597452968, -493048276407164]
theorem CU_021_5_pre_eq :
    CU_2_re_001 * Fplus_dW_re_020 - CU_2_im_001 * Fplus_dW_im_020 = CU_021_5_pre := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_021_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_5_pim_eq :
    CU_2_re_001 * Fplus_dW_im_020 + CU_2_im_001 * Fplus_dW_re_020 = CU_021_5_pim := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_021_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_5_mul :
    CU_2_c_001 * Fplus_dW_c_020 = ofLadj CU_021_5_pre CU_021_5_pim := by
  rw [CU_2_c_001_def, Fplus_dW_c_020_def, ofLadj_mul, CU_021_5_pre_eq, CU_021_5_pim_eq]

def CU_021_6_pre : Polynomial ℚ := interpQ 235794999 [-226647573768, 0, 671304042640, 1599520287464, 2437621152912, 2893947898512, 2893947898512, 2437621152912, 1599520287464, 671304042640]
def CU_021_6_pim : Polynomial ℚ := interpQ 235794999 [-848768711064, -1697537422128, -2322949837216, -2464592776488, -2057040964512, -1284386879440, -413150542688, 359503542384, 767055354360, 625412415088]
theorem CU_021_6_neg_re : -CU_3_re_021 = CU_021_6_pre := by
  simp only [CU_3_re_021_def, CU_021_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_6_neg_im : -CU_3_im_021 = CU_021_6_pim := by
  simp only [CU_3_im_021_def, CU_021_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_021_6_mul : -CU_3_c_021 = ofLadj CU_021_6_pre CU_021_6_pim := by
  rw [CU_3_c_021_def, ofLadj_neg, CU_021_6_neg_re, CU_021_6_neg_im]

@[expose] public def CU_coeff_021 : Ki := CU_0_c_010 * Fplus_dU_c_011 + CU_0_c_001 * Fplus_dU_c_020 + CU_1_c_010 * Fplus_dV_c_011 + CU_1_c_001 * Fplus_dV_c_020 + CU_2_c_010 * Fplus_dW_c_011 + CU_2_c_001 * Fplus_dW_c_020 + (-CU_3_c_021)

theorem CU_coeff_021_sum :
    CU_coeff_021 = ofLadj (CU_021_0_pre + CU_021_1_pre + CU_021_2_pre + CU_021_3_pre + CU_021_4_pre + CU_021_5_pre + CU_021_6_pre) (CU_021_0_pim + CU_021_1_pim + CU_021_2_pim + CU_021_3_pim + CU_021_4_pim + CU_021_5_pim + CU_021_6_pim) := by
  simp only [CU_coeff_021, CU_021_0_mul, CU_021_1_mul, CU_021_2_mul, CU_021_3_mul, CU_021_4_mul, CU_021_5_mul, CU_021_6_mul]
  simp [ofLadj_add, add_assoc]

def CU_021_qre : Polynomial ℚ := interpQ 235794999 [-60370722464192, 239096914098880, 220914523801262, 390592884421258, 704978828584332, 833579698438346, 727553054119394, 477207986164048, 52312394221936]
def CU_021_qim : Polynomial ℚ := interpQ 235794999 [-369106584129236, -369106584129236, -383737128280718, -561137570138182, -386000525487416, -121437452528886, 185346567825482, 455294077115084, 317440708080284]
theorem CU_coeff_021_poly_re :
    CU_021_0_pre + CU_021_1_pre + CU_021_2_pre + CU_021_3_pre + CU_021_4_pre + CU_021_5_pre + CU_021_6_pre = (0 : Polynomial ℚ) + Phi11 * CU_021_qre := by
  rw [phi11_interpQ]
  simp only [CU_021_0_pre, CU_021_1_pre, CU_021_2_pre, CU_021_3_pre, CU_021_4_pre, CU_021_5_pre, CU_021_6_pre, CU_021_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_021_poly_im :
    CU_021_0_pim + CU_021_1_pim + CU_021_2_pim + CU_021_3_pim + CU_021_4_pim + CU_021_5_pim + CU_021_6_pim = (0 : Polynomial ℚ) + Phi11 * CU_021_qim := by
  rw [phi11_interpQ]
  simp only [CU_021_0_pim, CU_021_1_pim, CU_021_2_pim, CU_021_3_pim, CU_021_4_pim, CU_021_5_pim, CU_021_6_pim, CU_021_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_021_eq :
    CU_coeff_021 = (0 : Ki) := by
  rw [CU_coeff_021_sum, CU_coeff_021_poly_re,
    CU_coeff_021_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
