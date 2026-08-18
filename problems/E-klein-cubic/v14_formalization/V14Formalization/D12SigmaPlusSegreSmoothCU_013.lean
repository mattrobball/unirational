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

def CU_013_0_pre : Polynomial ℚ := interpQ 235794999 [57986577568824, 948859537635744, 1894334240380880, 3074397557085720, 4672401862283432, 5649123284343080, 6538234071153192, 7131887454807380, 7012713689486528, 7106770137594344, 7178686753833220, 7147506438829112, 6229827216197476, 5212435897213464, 3938316132400808, 2253816949463572, 1225641326683468, 336530539873356, -205668643060376]
def CU_013_0_pim : Polynomial ℚ := interpQ 235794999 [-679681028441752, -1359362056883504, -1656069881855096, -2068647555082160, -1798323116102824, -1081549376254616, -527653998135296, 468549114570556, 1044819626115396, 1058315566396136, 1120552576421176, 1891502416392184, 2662452256363192, 3021397091359824, 3447470704867628, 3137716203380116, 2340930734073756, 1691915416217020, 615700574053016]
theorem CU_013_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_002 - CU_0_im_011 * Fplus_dU_im_002 = CU_013_0_pre := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_013_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_002 + CU_0_im_011 * Fplus_dU_re_002 = CU_013_0_pim := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_013_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_0_mul :
    CU_0_c_011 * Fplus_dU_c_002 = ofLadj CU_013_0_pre CU_013_0_pim := by
  rw [CU_0_c_011_def, Fplus_dU_c_002_def, ofLadj_mul, CU_013_0_pre_eq, CU_013_0_pim_eq]

def CU_013_1_pre : Polynomial ℚ := interpQ 235794999 [-566981103078832, -7677114372829120, -15619226236562928, -25671784926067968, -38218715411325824, -45418076540094352, -51215482369620896, -54399249975734688, -51825885948673120, -50846250167432736, -50098166696044672, -49252250826285872, -42421052323215552, -35227023930869808, -26154101022605152, -14507488710130016, -7843346706377728, -2045940876851184, 1673045854278848]
def CU_013_1_pim : Polynomial ℚ := interpQ 235794999 [5169725911250992, 10339451822501984, 12268015478865200, 14448788418429728, 10869393051371200, 3786341259632640, -1890496719909200, -10230321471065728, -15015217008647056, -14874390823794880, -14226296632771904, -18446259016560336, -22666221400348768, -23946690865689008, -25986637620401360, -22818329751565408, -16567926774588480, -11880983975753648, -4373808039358752]
theorem CU_013_1_pre_eq :
    CU_0_re_002 * Fplus_dU_re_011 - CU_0_im_002 * Fplus_dU_im_011 = CU_013_1_pre := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_013_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_1_pim_eq :
    CU_0_re_002 * Fplus_dU_im_011 + CU_0_im_002 * Fplus_dU_re_011 = CU_013_1_pim := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_013_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_1_mul :
    CU_0_c_002 * Fplus_dU_c_011 = ofLadj CU_013_1_pre CU_013_1_pim := by
  rw [CU_0_c_002_def, Fplus_dU_c_011_def, ofLadj_mul, CU_013_1_pre_eq, CU_013_1_pim_eq]

def CU_013_2_pre : Polynomial ℚ := interpQ 235794999 [-5277918908780, 121142661053008, 258649220943140, 441915190620720, 703641702034172, 910488783919784, 1072213877518836, 1120116851793016, 1012253491893296, 936408418696156, 878464417746868, 862144724375216, 757321756693860, 677759197753016, 570338301272576, 378331897673048, 212936010192340, 51210916593288, -38143252085796]
def CU_013_2_pim : Polynomial ℚ := interpQ 235794999 [-130033557096016, -260067114192032, -322491404874600, -409301247408688, -401093411177196, -282885543800572, -119736090885528, 104945915942636, 229012828236476, 218116795966544, 167933587841948, 224416440047936, 280899292253924, 293140374811896, 369054185076052, 392662402770348, 338940945220488, 252446455369452, 92250858368052]
theorem CU_013_2_pre_eq :
    CU_1_re_011 * Fplus_dV_re_002 - CU_1_im_011 * Fplus_dV_im_002 = CU_013_2_pre := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_013_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_2_pim_eq :
    CU_1_re_011 * Fplus_dV_im_002 + CU_1_im_011 * Fplus_dV_re_002 = CU_013_2_pim := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_013_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_2_mul :
    CU_1_c_011 * Fplus_dV_c_002 = ofLadj CU_013_2_pre CU_013_2_pim := by
  rw [CU_1_c_011_def, Fplus_dV_c_002_def, ofLadj_mul, CU_013_2_pre_eq, CU_013_2_pim_eq]

def CU_013_3_pre : Polynomial ℚ := interpQ 235794999 [1164938616564608, 16241657478533760, 32223570101646032, 52808730021171920, 78755938296789776, 93801602763009328, 106107869768415472, 113497544651820720, 108156962119982128, 106934675319176464, 106001463711599600, 104488594652339552, 89759806233065840, 74711105217530432, 55348232098810208, 30524257027446304, 16146214344097520, 3839947338691376, -4217349327584640]
def CU_013_3_pim : Polynomial ℚ := interpQ 235794999 [-11053261048104512, -22106522096209024, -25933415370439824, -31137405892831920, -23888303963210592, -9222312748364672, 2724433178980672, 20606448637717040, 31063632468523152, 30887880258126784, 30079249592407040, 39947679522516128, 49816109452625216, 52834372061136272, 57862610373132000, 51126494901711456, 37499291052647584, 26787425465559648, 9944197372605328]
theorem CU_013_3_pre_eq :
    CU_1_re_002 * Fplus_dV_re_011 - CU_1_im_002 * Fplus_dV_im_011 = CU_013_3_pre := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_013_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_3_pim_eq :
    CU_1_re_002 * Fplus_dV_im_011 + CU_1_im_002 * Fplus_dV_re_011 = CU_013_3_pim := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_013_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_3_mul :
    CU_1_c_002 * Fplus_dV_c_011 = ofLadj CU_013_3_pre CU_013_3_pim := by
  rw [CU_1_c_002_def, Fplus_dV_c_011_def, ofLadj_mul, CU_013_3_pre_eq, CU_013_3_pim_eq]

def CU_013_4_pre : Polynomial ℚ := interpQ 235794999 [-14534304318684, 0, 39060397675188, 90103148003496, 137069371005672, 165000265537704, 165000265537704, 137069371005672, 90103148003496, 39060397675188]
def CU_013_4_pim : Polynomial ℚ := interpQ 235794999 [-49546960564476, -99093921128952, -132886341613524, -140198018587404, -118811513745720, -75357039745596, -23736881383356, 19717592616768, 41104097458452, 33792420484572]
theorem CU_013_4_pre_eq :
    CU_2_re_011 * Fplus_dW_re_002 - CU_2_im_011 * Fplus_dW_im_002 = CU_013_4_pre := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_013_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_4_pim_eq :
    CU_2_re_011 * Fplus_dW_im_002 + CU_2_im_011 * Fplus_dW_re_002 = CU_013_4_pim := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_013_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_4_mul :
    CU_2_c_011 * Fplus_dW_c_002 = ofLadj CU_013_4_pre CU_013_4_pim := by
  rw [CU_2_c_011_def, Fplus_dW_c_002_def, ofLadj_mul, CU_013_4_pre_eq, CU_013_4_pim_eq]

def CU_013_5_pre : Polynomial ℚ := interpQ 235794999 [19142653431904, -439668093439616, -938663949110256, -1604177680512288, -2554076651618144, -3304635465834576, -3892001154530288, -4065871798866656, -3674198810766672, -3398716415783760, -3188500497209360, -3129321820591392, -2748832403769744, -2460052466673504, -2070021130254384, -1373228643696336, -773000375550912, -185634686855200, 138566503552176]
def CU_013_5_pim : Polynomial ℚ := interpQ 235794999 [471933012637568, 943866025275136, 1170601699648544, 1485754380661760, 1455571416283232, 1026786643551072, 434644090095472, -381168084898416, -831609081031232, -791971286523968, -609696193243072, -814732761422528, -1019769329601984, -1064229910694496, -1339744797200448, -1425233289059424, -1230516221716416, -916514009500048, -334769539895312]
theorem CU_013_5_pre_eq :
    CU_2_re_002 * Fplus_dW_re_011 - CU_2_im_002 * Fplus_dW_im_011 = CU_013_5_pre := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_013_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_5_pim_eq :
    CU_2_re_002 * Fplus_dW_im_011 + CU_2_im_002 * Fplus_dW_re_011 = CU_013_5_pim := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_013_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_013_5_mul :
    CU_2_c_002 * Fplus_dW_c_011 = ofLadj CU_013_5_pre CU_013_5_pim := by
  rw [CU_2_c_002_def, Fplus_dW_c_011_def, ofLadj_mul, CU_013_5_pre_eq, CU_013_5_pim_eq]

@[expose] public def CU_coeff_013 : Ki := CU_0_c_011 * Fplus_dU_c_002 + CU_0_c_002 * Fplus_dU_c_011 + CU_1_c_011 * Fplus_dV_c_002 + CU_1_c_002 * Fplus_dV_c_011 + CU_2_c_011 * Fplus_dW_c_002 + CU_2_c_002 * Fplus_dW_c_011

theorem CU_coeff_013_sum :
    CU_coeff_013 = ofLadj (CU_013_0_pre + CU_013_1_pre + CU_013_2_pre + CU_013_3_pre + CU_013_4_pre + CU_013_5_pre) (CU_013_0_pim + CU_013_1_pim + CU_013_2_pim + CU_013_3_pim + CU_013_4_pim + CU_013_5_pim) := by
  simp only [CU_coeff_013, CU_013_0_mul, CU_013_1_mul, CU_013_2_mul, CU_013_3_mul, CU_013_4_mul, CU_013_5_mul]
  simpa [add_assoc] using ofLadj_add6 CU_013_0_pre CU_013_0_pim CU_013_1_pre CU_013_1_pim CU_013_2_pre CU_013_2_pim CU_013_3_pre CU_013_3_pim CU_013_4_pre CU_013_4_pim CU_013_5_pre CU_013_5_pim

def CU_013_qre : Polynomial ℚ := interpQ 235794999 [655274521259040, 8539602689694736, 8662846564018280, 11281459535329544, 14357075858867484, 8307243921711884, 6972331367593052, 4645662096351424, -2649548864899788]
def CU_013_qim : Polynomial ℚ := interpQ 235794999 [-6270863670318196, -6270863670318196, -2064518479632908, -3214764094549384, 3939442378236784, 8032590731600156, 6446430383744508, 9990718126120092, 5943571225772332]
theorem CU_coeff_013_poly_re :
    CU_013_0_pre + CU_013_1_pre + CU_013_2_pre + CU_013_3_pre + CU_013_4_pre + CU_013_5_pre = (0 : Polynomial ℚ) + Phi11 * CU_013_qre := by
  rw [phi11_interpQ]
  simp only [CU_013_0_pre, CU_013_1_pre, CU_013_2_pre, CU_013_3_pre, CU_013_4_pre, CU_013_5_pre, CU_013_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_013_poly_im :
    CU_013_0_pim + CU_013_1_pim + CU_013_2_pim + CU_013_3_pim + CU_013_4_pim + CU_013_5_pim = (0 : Polynomial ℚ) + Phi11 * CU_013_qim := by
  rw [phi11_interpQ]
  simp only [CU_013_0_pim, CU_013_1_pim, CU_013_2_pim, CU_013_3_pim, CU_013_4_pim, CU_013_5_pim, CU_013_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_013_eq :
    CU_coeff_013 = (0 : Ki) := by
  rw [CU_coeff_013_sum, CU_coeff_013_poly_re,
    CU_coeff_013_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
