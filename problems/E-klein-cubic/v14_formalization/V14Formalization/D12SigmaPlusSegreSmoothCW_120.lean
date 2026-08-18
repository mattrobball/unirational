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

def CW_120_0_pre : Polynomial ℚ := interpQ 17279915862 [443580621895, -34754253928140, -64778757529218, -112570399269033, -184247010394417, -237006729411699, -290018347862945, -331292561229814, -337010937106623, -348481751545737, -357826281911684, -361121731909270, -323072027983544, -283702994016519, -224440537837590, -141603147845597, -82480474823370, -29468856372124, 5442402989800]
def CW_120_0_pim : Polynomial ℚ := interpQ 17279915862 [32227040575369, 64454081150738, 86494043196518, 122714716342167, 127308111957687, 114146961555373, 99949602986129, 59762348338700, 31316048586623, 29846624052987, 21837602272942, -21714670699002, -65266943670946, -95315927496771, -133006025176056, -133075487364353, -109411519623802, -83660305164966, -32970233179300]
theorem CW_120_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_020 - CW_0_im_100 * Fplus_dU_im_020 = CW_120_0_pre := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_120_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_020 + CW_0_im_100 * Fplus_dU_re_020 = CW_120_0_pim := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_120_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_0_mul :
    CW_0_c_100 * Fplus_dU_c_020 = ofLadj CW_120_0_pre CW_120_0_pim := by
  rw [CW_0_c_100_def, Fplus_dU_c_020_def, ofLadj_mul, CW_120_0_pre_eq, CW_120_0_pim_eq]

def CW_120_1_pre : Polynomial ℚ := interpQ 17279915862 [-910979482648, 17855596888064, 34041169745992, 56704600072648, 96890816358806, 122366520347250, 149674457274020, 159964582393288, 148214652432352, 140953442038506, 134196585005350, 133765825997448, 116340988117286, 106912272292514, 91510052359704, 59206228130354, 37952902062734, 10644965135964, -3867537904128]
def CW_120_1_pim : Polynomial ℚ := interpQ 17279915862 [-17159326906960, -34318653813920, -43307593895684, -61114594318212, -60035650690622, -45268612252710, -28441777928816, 6635752108588, 23088360705812, 22376774437918, 16673520957650, 26383500836112, 36093480714574, 39379167316070, 56474581470704, 57974464570094, 50878825586814, 41279912453016, 13873781870244]
theorem CW_120_1_pre_eq :
    CW_0_re_010 * Fplus_dU_re_110 - CW_0_im_010 * Fplus_dU_im_110 = CW_120_1_pre := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_120_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_1_pim_eq :
    CW_0_re_010 * Fplus_dU_im_110 + CW_0_im_010 * Fplus_dU_re_110 = CW_120_1_pim := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_120_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_1_mul :
    CW_0_c_010 * Fplus_dU_c_110 = ofLadj CW_120_1_pre CW_120_1_pim := by
  rw [CW_0_c_010_def, Fplus_dU_c_110_def, ofLadj_mul, CW_120_1_pre_eq, CW_120_1_pim_eq]

def CW_120_2_pre : Polynomial ℚ := interpQ 17279915862 [2403216916536, 25865088524976, 44672881001487, 72208238511354, 109483376912892, 123781836973074, 142546519788186, 163489573610205, 167484572514465, 180512862423297, 190499742603882, 191847400013886, 164634654078906, 135839981421810, 95276334003111, 45989269162533, 24457817825268, 5693135010156, -8016927534780]
def CW_120_2_pim : Polynomial ℚ := interpQ 17279915862 [-14964071869842, -29928143739684, -33972917294763, -44748938159076, -33324526601958, -15379924485618, -10860202923348, 7820576661723, 21753851360991, 23660392519101, 32285826720684, 59926415145474, 87567003570264, 100237211326926, 112919773349349, 96040986207009, 66973745388930, 49191068571300, 19387650284490]
theorem CW_120_2_pre_eq :
    CW_1_re_100 * Fplus_dV_re_020 - CW_1_im_100 * Fplus_dV_im_020 = CW_120_2_pre := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_120_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_2_pim_eq :
    CW_1_re_100 * Fplus_dV_im_020 + CW_1_im_100 * Fplus_dV_re_020 = CW_120_2_pim := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_120_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_2_mul :
    CW_1_c_100 * Fplus_dV_c_020 = ofLadj CW_120_2_pre CW_120_2_pim := by
  rw [CW_1_c_100_def, Fplus_dV_c_020_def, ofLadj_mul, CW_120_2_pre_eq, CW_120_2_pim_eq]

def CW_120_3_pre : Polynomial ℚ := interpQ 17279915862 [-1132656290854, 24825587592200, 45815555203444, 78530835855980, 130722528020872, 168515441811326, 205002656451174, 234441465343660, 239034823006538, 246694736777958, 253524164004834, 256760126473456, 228698576412634, 200879181574514, 160503987150558, 100300556004040, 57466862259604, 20979647619756, -3418381318748]
def CW_120_3_pim : Polynomial ℚ := interpQ 17279915862 [-23260294508930, -46520589017860, -61045126687224, -88009449166252, -92020071976308, -81533412251386, -71418492830066, -44043404478164, -23370058454330, -22352274056806, -16780631892922, 14544072573700, 45868777040322, 65964956873570, 93947063750122, 95185737455800, 77050897856428, 58468563354564, 23445295128212]
theorem CW_120_3_pre_eq :
    CW_1_re_010 * Fplus_dV_re_110 - CW_1_im_010 * Fplus_dV_im_110 = CW_120_3_pre := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_120_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_3_pim_eq :
    CW_1_re_010 * Fplus_dV_im_110 + CW_1_im_010 * Fplus_dV_re_110 = CW_120_3_pim := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_120_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_3_mul :
    CW_1_c_010 * Fplus_dV_c_110 = ofLadj CW_120_3_pre CW_120_3_pim := by
  rw [CW_1_c_010_def, Fplus_dV_c_110_def, ofLadj_mul, CW_120_3_pre_eq, CW_120_3_pim_eq]

def CW_120_4_pre : Polynomial ℚ := interpQ 17279915862 [-172753735524, 27886160636488, 52995661419529, 88273124602623, 133216786650533, 155222721074264, 179360862830530, 189934195399914, 181126293077277, 178802507236711, 177574224324169, 176672500097372, 149688063687681, 125806845817182, 92853168474654, 49560856329487, 28890007690966, 4751865934700, -7156552419894]
def CW_120_4_pim : Polynomial ℚ := interpQ 17279915862 [-19872651317848, -39745302635696, -44182591244663, -56983963748911, -41146013539311, -18926981187690, 408451159146, 31569810761422, 48318050330335, 47723759164485, 46508438841459, 64330267714118, 82152096586777, 85374064872718, 97581146211116, 82997833332019, 62133147244300, 45300615576784, 15493602238410]
theorem CW_120_4_pre_eq :
    CW_2_re_100 * Fplus_dW_re_020 - CW_2_im_100 * Fplus_dW_im_020 = CW_120_4_pre := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_120_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_4_pim_eq :
    CW_2_re_100 * Fplus_dW_im_020 + CW_2_im_100 * Fplus_dW_re_020 = CW_120_4_pim := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_120_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_4_mul :
    CW_2_c_100 * Fplus_dW_c_020 = ofLadj CW_120_4_pre CW_120_4_pim := by
  rw [CW_2_c_100_def, Fplus_dW_c_020_def, ofLadj_mul, CW_120_4_pre_eq, CW_120_4_pim_eq]

def CW_120_5_pre : Polynomial ℚ := interpQ 17279915862 [-5768081995024, -4301654065600, -15674978502172, -15999228794696, -20835278096360, -35084323200988, -26694585952112, -35887484076242, -36096413849048, -35603734712974, -35213775200726, -29959200298732, -30912121135126, -19928756210802, -20097185054352, -15929276864886, -1432714429928, -9822451678804, -877070885004]
def CW_120_5_pim : Polynomial ℚ := interpQ 17279915862 [625713906600, 1251427813200, 5075618237000, -5017594237700, 5942342999948, -6409589857144, -10402172004716, -8599346188250, -15828972433340, -15891211980498, -15293187728906, -15734268541200, -16175349353494, -19401515525702, -9370542598160, -20423333425170, -8764576071424, -4640771335916, -7136772655728]
theorem CW_120_5_pre_eq :
    CW_2_re_010 * Fplus_dW_re_110 - CW_2_im_010 * Fplus_dW_im_110 = CW_120_5_pre := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_120_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_5_pim_eq :
    CW_2_re_010 * Fplus_dW_im_110 + CW_2_im_010 * Fplus_dW_re_110 = CW_120_5_pim := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_120_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_5_mul :
    CW_2_c_010 * Fplus_dW_c_110 = ofLadj CW_120_5_pre CW_120_5_pim := by
  rw [CW_2_c_010_def, Fplus_dW_c_110_def, ofLadj_mul, CW_120_5_pre_eq, CW_120_5_pim_eq]

def CW_120_6_pre : Polynomial ℚ := interpQ 17279915862 [-72587582716, 0, -123403391936, 1668750864, -1045542432, 104790647324, 104790647324, -1045542432, 1668750864, -123403391936]
def CW_120_6_pim : Polynomial ℚ := interpQ 17279915862 [-100157736684, -200315473368, -67820507088, -154604548184, -192823753928, -257392731164, 57077257796, -7491719440, -45710925184, -132494966280]
theorem CW_120_6_neg_re : -CW_3_re_120 = CW_120_6_pre := by
  simp only [CW_3_re_120_def, CW_120_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_6_neg_im : -CW_3_im_120 = CW_120_6_pim := by
  simp only [CW_3_im_120_def, CW_120_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_120_6_mul : -CW_3_c_120 = ofLadj CW_120_6_pre CW_120_6_pim := by
  rw [CW_3_c_120_def, ofLadj_neg, CW_120_6_neg_re, CW_120_6_neg_im]

@[expose] public def CW_coeff_120 : Ki := CW_0_c_100 * Fplus_dU_c_020 + CW_0_c_010 * Fplus_dU_c_110 + CW_1_c_100 * Fplus_dV_c_020 + CW_1_c_010 * Fplus_dV_c_110 + CW_2_c_100 * Fplus_dW_c_020 + CW_2_c_010 * Fplus_dW_c_110 + (-CW_3_c_120)

theorem CW_coeff_120_sum :
    CW_coeff_120 = ofLadj (CW_120_0_pre + CW_120_1_pre + CW_120_2_pre + CW_120_3_pre + CW_120_4_pre + CW_120_5_pre + CW_120_6_pre) (CW_120_0_pim + CW_120_1_pim + CW_120_2_pim + CW_120_3_pim + CW_120_4_pim + CW_120_5_pim + CW_120_6_pim) := by
  simp only [CW_coeff_120, CW_120_0_mul, CW_120_1_mul, CW_120_2_mul, CW_120_3_mul, CW_120_4_mul, CW_120_5_mul, CW_120_6_mul]
  simp [ofLadj_add, add_assoc]

def CW_120_qre : Polynomial ℚ := interpQ 17279915862 [-5210261548335, 62586787196323, 39571602299138, 70200711782614, 98081334180154, 32670084330657, 62076094935626, 20672372722402, -17894067072754]
def CW_120_qim : Polynomial ℚ := interpQ 17279915862 [-42503747858295, -42503747858295, -5998892479314, -42308039640264, 39845796231676, 39839680394153, 32921436926464, 73845759768454, 32093323686328]
theorem CW_coeff_120_poly_re :
    CW_120_0_pre + CW_120_1_pre + CW_120_2_pre + CW_120_3_pre + CW_120_4_pre + CW_120_5_pre + CW_120_6_pre = (0 : Polynomial ℚ) + Phi11 * CW_120_qre := by
  rw [phi11_interpQ]
  simp only [CW_120_0_pre, CW_120_1_pre, CW_120_2_pre, CW_120_3_pre, CW_120_4_pre, CW_120_5_pre, CW_120_6_pre, CW_120_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_120_poly_im :
    CW_120_0_pim + CW_120_1_pim + CW_120_2_pim + CW_120_3_pim + CW_120_4_pim + CW_120_5_pim + CW_120_6_pim = (0 : Polynomial ℚ) + Phi11 * CW_120_qim := by
  rw [phi11_interpQ]
  simp only [CW_120_0_pim, CW_120_1_pim, CW_120_2_pim, CW_120_3_pim, CW_120_4_pim, CW_120_5_pim, CW_120_6_pim, CW_120_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_120_eq :
    CW_coeff_120 = (0 : Ki) := by
  rw [CW_coeff_120_sum, CW_coeff_120_poly_re,
    CW_coeff_120_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
