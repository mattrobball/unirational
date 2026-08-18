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

def CU_012_0_pre : Polynomial ℚ := interpQ 235794999 [-28067922095632, -457761279463264, -913984981957620, -1483543233641074, -2254435729179454, -2725682108627230, -3154814466227600, -3441231994347732, -3383639115918846, -3429027972680974, -3463727022568036, -3448583809475236, -3005965743104772, -2515042990723354, -1900095882277772, -1087463108862314, -591397855001524, -162265497401154, 99333156305964]
def CU_012_0_pim : Polynomial ℚ := interpQ 235794999 [327864374025900, 655728748051800, 799077149539960, 998004481653134, 867432828467726, 521692261881794, 254397422230484, -226412573055136, -504474378388538, -510986823197862, -541025886167900, -912923773426432, -1284821660684964, -1458209125143162, -1663648902065660, -1514046217842954, -1129693871304924, -816514611608418, -297092836370700]
theorem CU_012_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_002 - CU_0_im_010 * Fplus_dU_im_002 = CU_012_0_pre := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_012_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_002 + CU_0_im_010 * Fplus_dU_re_002 = CU_012_0_pim := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_012_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_0_mul :
    CU_0_c_010 * Fplus_dU_c_002 = ofLadj CU_012_0_pre CU_012_0_pim := by
  rw [CU_0_c_010_def, Fplus_dU_c_002_def, ofLadj_mul, CU_012_0_pre_eq, CU_012_0_pim_eq]

def CU_012_1_pre : Polynomial ℚ := interpQ 235794999 [235152936259664, 3182632231511360, 6475220938954800, 10643928723314336, 15845488823694824, 18829802296380712, 21234330271455568, 22553912781713516, 21486596324542576, 21080486081369464, 20770283868933532, 20419415108098912, 17587651637422172, 14605265142414664, 10842667601228240, 6014368671183780, 3252043880552392, 847515905477536, -694055286834912]
def CU_012_1_pim : Polynomial ℚ := interpQ 235794999 [-2143123139581056, -4286246279162112, -5086375500615800, -5990451251502552, -4505392276944808, -1569455067165320, 784336268460664, 4242890354942876, 6226512799286392, 6168151385358704, 5899507154429796, 7648791629075568, 9398076103721340, 9929561094246120, 10775275431205184, 9460592918141428, 6869868292220032, 4926587485473648, 1813245982849528]
theorem CU_012_1_pre_eq :
    CU_0_re_001 * Fplus_dU_re_011 - CU_0_im_001 * Fplus_dU_im_011 = CU_012_1_pre := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_012_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_1_pim_eq :
    CU_0_re_001 * Fplus_dU_im_011 + CU_0_im_001 * Fplus_dU_re_011 = CU_012_1_pim := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_012_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_1_mul :
    CU_0_c_001 * Fplus_dU_c_011 = ofLadj CU_012_1_pre CU_012_1_pim := by
  rw [CU_0_c_001_def, Fplus_dU_c_011_def, ofLadj_mul, CU_012_1_pre_eq, CU_012_1_pim_eq]

def CU_012_2_pre : Polynomial ℚ := interpQ 235794999 [2435199337218, -55306984964312, -118065381311726, -201586407075710, -321068877742176, -415530062375254, -489229677400612, -511060805579574, -461905134102314, -427355177419180, -400886042974604, -393426921831496, -345579058010292, -309289796107454, -260318727026604, -172631051309170, -97137803038596, -23438188013238, 17360876528228]
def CU_012_2_pim : Polynomial ℚ := interpQ 235794999 [59372471358886, 118744942717772, 147154617273650, 186794257016522, 183160808056476, 129145705866142, 54671217134836, -47751086387034, -104312963465338, -99367411357868, -76518713419320, -102296861501396, -128075009583472, -133635986200802, -168330073836204, -179156021836206, -154556366539848, -115109336746150, -42102480118256]
theorem CU_012_2_pre_eq :
    CU_1_re_010 * Fplus_dV_re_002 - CU_1_im_010 * Fplus_dV_im_002 = CU_012_2_pre := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_012_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_2_pim_eq :
    CU_1_re_010 * Fplus_dV_im_002 + CU_1_im_010 * Fplus_dV_re_002 = CU_012_2_pim := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_012_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_2_mul :
    CU_1_c_010 * Fplus_dV_c_002 = ofLadj CU_012_2_pre CU_012_2_pim := by
  rw [CU_1_c_010_def, Fplus_dV_c_002_def, ofLadj_mul, CU_012_2_pre_eq, CU_012_2_pim_eq]

def CU_012_3_pre : Polynomial ℚ := interpQ 235794999 [-436344324422928, -6084903947254272, -12072320660026472, -19784842241586728, -29505966984028312, -35142464145936380, -39753484458910880, -42521751405758244, -40520829638556108, -40062886180542284, -39713279497385312, -39146527975346176, -33628375550131040, -27990565520515812, -20735987396969380, -11435658306916396, -6049319528026880, -1438299215052380, 1580126114813536]
def CU_012_3_pim : Polynomial ℚ := interpQ 235794999 [4141121946607248, 8282243893214496, 9716003359052896, 11665952218297088, 8949571286974696, 3455329726752276, -1020560263630072, -7720348224519556, -11637978017880948, -11572115850221044, -11269193456977136, -14966395724282640, -18663597991588144, -19794435064182636, -21678521755766924, -19154344643035852, -14049248063994392, -10036068954478596, -3725425974770072]
theorem CU_012_3_pre_eq :
    CU_1_re_001 * Fplus_dV_re_011 - CU_1_im_001 * Fplus_dV_im_011 = CU_012_3_pre := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_012_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_3_pim_eq :
    CU_1_re_001 * Fplus_dV_im_011 + CU_1_im_001 * Fplus_dV_re_011 = CU_012_3_pim := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_012_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_3_mul :
    CU_1_c_001 * Fplus_dV_c_011 = ofLadj CU_012_3_pre CU_012_3_pim := by
  rw [CU_1_c_001_def, Fplus_dV_c_011_def, ofLadj_mul, CU_012_3_pre_eq, CU_012_3_pim_eq]

def CU_012_4_pre : Polynomial ℚ := interpQ 235794999 [5927576757018, 0, -16082625292086, -37222783575240, -56635835521974, -68077329470532, -68077329470532, -56635835521974, -37222783575240, -16082625292086]
def CU_012_4_pim : Polynomial ℚ := interpQ 235794999 [20393171172222, 40786342344444, 54809142721374, 57857917465980, 48954913369722, 31000028168304, 9786314176140, -8168571025278, -17071575121536, -14022800376930]
theorem CU_012_4_pre_eq :
    CU_2_re_010 * Fplus_dW_re_002 - CU_2_im_010 * Fplus_dW_im_002 = CU_012_4_pre := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_012_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_4_pim_eq :
    CU_2_re_010 * Fplus_dW_im_002 + CU_2_im_010 * Fplus_dW_re_002 = CU_012_4_pim := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_012_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_4_mul :
    CU_2_c_010 * Fplus_dW_c_002 = ofLadj CU_012_4_pre CU_012_4_pim := by
  rw [CU_2_c_010_def, Fplus_dW_c_002_def, ofLadj_mul, CU_012_4_pre_eq, CU_012_4_pim_eq]

def CU_012_5_pre : Polynomial ℚ := interpQ 235794999 [-4992888049432, 115035282307872, 245586924215848, 419893543150944, 668432306292520, 864752098164476, 1018613914444748, 1064129430108232, 961551226666020, 889374936548212, 834403895256676, 818939237310512, 719368612948804, 643788012332364, 541657683515076, 359379063067056, 202339488750920, 48477672470648, -36318060748656]
def CU_012_5_pim : Polynomial ℚ := interpQ 235794999 [-123473209464472, -246946418928944, -306363595052632, -388842830890368, -380778788833160, -268679085264396, -113738440995700, 99892548517120, 217832557183932, 207420911944428, 159658885800580, 213320799168328, 266982712536076, 278637862515916, 350705453114148, 372994839291080, 322156837023736, 239955868644072, 87586580432672]
theorem CU_012_5_pre_eq :
    CU_2_re_001 * Fplus_dW_re_011 - CU_2_im_001 * Fplus_dW_im_011 = CU_012_5_pre := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_012_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_5_pim_eq :
    CU_2_re_001 * Fplus_dW_im_011 + CU_2_im_001 * Fplus_dW_re_011 = CU_012_5_pim := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_012_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_5_mul :
    CU_2_c_001 * Fplus_dW_c_011 = ofLadj CU_012_5_pre CU_012_5_pim := by
  rw [CU_2_c_001_def, Fplus_dW_c_011_def, ofLadj_mul, CU_012_5_pre_eq, CU_012_5_pim_eq]

def CU_012_6_pre : Polynomial ℚ := interpQ 235794999 [2868984719832, 0, -7713860720896, -17755677793832, -27013769416128, -32533730109848, -32533730109848, -27013769416128, -17755677793832, -7713860720896]
def CU_012_6_pim : Polynomial ℚ := interpQ 235794999 [9776300513864, 19552601027728, 26204029511136, 27633038975672, 23438337857872, 14867586022616, 4685015005112, -3885736830144, -8080437947944, -6651428483408]
theorem CU_012_6_neg_re : -CU_3_re_012 = CU_012_6_pre := by
  simp only [CU_3_re_012_def, CU_012_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_6_neg_im : -CU_3_im_012 = CU_012_6_pim := by
  simp only [CU_3_im_012_def, CU_012_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_012_6_mul : -CU_3_c_012 = ofLadj CU_012_6_pre CU_012_6_pim := by
  rw [CU_3_c_012_def, ofLadj_neg, CU_012_6_neg_re, CU_012_6_neg_im]

@[expose] public def CU_coeff_012 : Ki := CU_0_c_010 * Fplus_dU_c_002 + CU_0_c_001 * Fplus_dU_c_011 + CU_1_c_010 * Fplus_dV_c_002 + CU_1_c_001 * Fplus_dV_c_011 + CU_2_c_010 * Fplus_dW_c_002 + CU_2_c_001 * Fplus_dW_c_011 + (-CU_3_c_012)

theorem CU_coeff_012_sum :
    CU_coeff_012 = ofLadj (CU_012_0_pre + CU_012_1_pre + CU_012_2_pre + CU_012_3_pre + CU_012_4_pre + CU_012_5_pre + CU_012_6_pre) (CU_012_0_pim + CU_012_1_pim + CU_012_2_pim + CU_012_3_pim + CU_012_4_pim + CU_012_5_pim + CU_012_6_pim) := by
  simp only [CU_coeff_012, CU_012_0_mul, CU_012_1_mul, CU_012_2_mul, CU_012_3_mul, CU_012_4_mul, CU_012_5_mul, CU_012_6_mul]
  simp [ofLadj_add, add_assoc]

def CU_012_qre : Polynomial ℚ := interpQ 235794999 [-223020437494260, -3077284260368356, -3107054948275536, -4053768431069152, -5190071988693396, -3038532916073356, -2555462494245100, -1694456122582748, 966446800064160]
def CU_012_qim : Polynomial ℚ := interpQ 235794999 [2291931914632592, 2291931914632592, 766645373165400, 1206438628584892, -1370560722066952, -2872485952687108, -2340323623879952, -3637360820738616, -2163788727976828]
theorem CU_coeff_012_poly_re :
    CU_012_0_pre + CU_012_1_pre + CU_012_2_pre + CU_012_3_pre + CU_012_4_pre + CU_012_5_pre + CU_012_6_pre = (0 : Polynomial ℚ) + Phi11 * CU_012_qre := by
  rw [phi11_interpQ]
  simp only [CU_012_0_pre, CU_012_1_pre, CU_012_2_pre, CU_012_3_pre, CU_012_4_pre, CU_012_5_pre, CU_012_6_pre, CU_012_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_012_poly_im :
    CU_012_0_pim + CU_012_1_pim + CU_012_2_pim + CU_012_3_pim + CU_012_4_pim + CU_012_5_pim + CU_012_6_pim = (0 : Polynomial ℚ) + Phi11 * CU_012_qim := by
  rw [phi11_interpQ]
  simp only [CU_012_0_pim, CU_012_1_pim, CU_012_2_pim, CU_012_3_pim, CU_012_4_pim, CU_012_5_pim, CU_012_6_pim, CU_012_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_012_eq :
    CU_coeff_012 = (0 : Ki) := by
  rw [CU_coeff_012_sum, CU_coeff_012_poly_re,
    CU_coeff_012_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
