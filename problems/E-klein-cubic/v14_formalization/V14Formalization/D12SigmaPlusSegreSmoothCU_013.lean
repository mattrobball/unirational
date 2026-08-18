/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CU_013_0_pre : Polynomial ℚ := C ((19328859189608 / 78598333 : ℚ)) + C ((316286512545248 / 78598333 : ℚ)) * X + C ((1894334240380880 / 235794999 : ℚ)) * X ^ 2 + C ((1024799185695240 / 78598333 : ℚ)) * X ^ 3 + C ((4672401862283432 / 235794999 : ℚ)) * X ^ 4 + C ((5649123284343080 / 235794999 : ℚ)) * X ^ 5 + C ((2179411357051064 / 78598333 : ℚ)) * X ^ 6 + C ((7131887454807380 / 235794999 : ℚ)) * X ^ 7 + C ((7012713689486528 / 235794999 : ℚ)) * X ^ 8 + C ((7106770137594344 / 235794999 : ℚ)) * X ^ 9 + C ((7178686753833220 / 235794999 : ℚ)) * X ^ 10 + C ((7147506438829112 / 235794999 : ℚ)) * X ^ 11 + C ((6229827216197476 / 235794999 : ℚ)) * X ^ 12 + C ((1737478632404488 / 78598333 : ℚ)) * X ^ 13 + C ((3938316132400808 / 235794999 : ℚ)) * X ^ 14 + C ((2253816949463572 / 235794999 : ℚ)) * X ^ 15 + C ((1225641326683468 / 235794999 : ℚ)) * X ^ 16 + C ((112176846624452 / 78598333 : ℚ)) * X ^ 17 + C ((-205668643060376 / 235794999 : ℚ)) * X ^ 18
def CU_013_0_pim : Polynomial ℚ := C ((-679681028441752 / 235794999 : ℚ)) + C ((-1359362056883504 / 235794999 : ℚ)) * X + C ((-1656069881855096 / 235794999 : ℚ)) * X ^ 2 + C ((-2068647555082160 / 235794999 : ℚ)) * X ^ 3 + C ((-1798323116102824 / 235794999 : ℚ)) * X ^ 4 + C ((-1081549376254616 / 235794999 : ℚ)) * X ^ 5 + C ((-527653998135296 / 235794999 : ℚ)) * X ^ 6 + C ((468549114570556 / 235794999 : ℚ)) * X ^ 7 + C ((348273208705132 / 78598333 : ℚ)) * X ^ 8 + C ((1058315566396136 / 235794999 : ℚ)) * X ^ 9 + C ((1120552576421176 / 235794999 : ℚ)) * X ^ 10 + C ((1891502416392184 / 235794999 : ℚ)) * X ^ 11 + C ((2662452256363192 / 235794999 : ℚ)) * X ^ 12 + C ((1007132363786608 / 78598333 : ℚ)) * X ^ 13 + C ((3447470704867628 / 235794999 : ℚ)) * X ^ 14 + C ((3137716203380116 / 235794999 : ℚ)) * X ^ 15 + C ((70937294971932 / 7145303 : ℚ)) * X ^ 16 + C ((1691915416217020 / 235794999 : ℚ)) * X ^ 17 + C ((615700574053016 / 235794999 : ℚ)) * X ^ 18
theorem CU_013_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_002 - CU_0_im_011 * Fplus_dU_im_002 = CU_013_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_002, Fplus_dU_im_002, CU_013_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_002 + CU_0_im_011 * Fplus_dU_re_002 = CU_013_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_002, Fplus_dU_im_002, CU_013_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_0_mul :
    CU_0_c_011 * Fplus_dU_c_002 = ofLadj CU_013_0_pre CU_013_0_pim := by
  rw [CU_0_c_011, Fplus_dU_c_002, ofLadj_mul, CU_013_0_pre_eq, CU_013_0_pim_eq]

def CU_013_1_pre : Polynomial ℚ := C ((-566981103078832 / 235794999 : ℚ)) + C ((-7677114372829120 / 235794999 : ℚ)) * X + C ((-5206408745520976 / 78598333 : ℚ)) * X ^ 2 + C ((-8557261642022656 / 78598333 : ℚ)) * X ^ 3 + C ((-38218715411325824 / 235794999 : ℚ)) * X ^ 4 + C ((-45418076540094352 / 235794999 : ℚ)) * X ^ 5 + C ((-51215482369620896 / 235794999 : ℚ)) * X ^ 6 + C ((-18133083325244896 / 78598333 : ℚ)) * X ^ 7 + C ((-51825885948673120 / 235794999 : ℚ)) * X ^ 8 + C ((-16948750055810912 / 78598333 : ℚ)) * X ^ 9 + C ((-50098166696044672 / 235794999 : ℚ)) * X ^ 10 + C ((-49252250826285872 / 235794999 : ℚ)) * X ^ 11 + C ((-14140350774405184 / 78598333 : ℚ)) * X ^ 12 + C ((-11742341310289936 / 78598333 : ℚ)) * X ^ 13 + C ((-26154101022605152 / 235794999 : ℚ)) * X ^ 14 + C ((-14507488710130016 / 235794999 : ℚ)) * X ^ 15 + C ((-7843346706377728 / 235794999 : ℚ)) * X ^ 16 + C ((-681980292283728 / 78598333 : ℚ)) * X ^ 17 + C ((1673045854278848 / 235794999 : ℚ)) * X ^ 18
def CU_013_1_pim : Polynomial ℚ := C ((5169725911250992 / 235794999 : ℚ)) + C ((10339451822501984 / 235794999 : ℚ)) * X + C ((12268015478865200 / 235794999 : ℚ)) * X ^ 2 + C ((1313526219857248 / 21435909 : ℚ)) * X ^ 3 + C ((10869393051371200 / 235794999 : ℚ)) * X ^ 4 + C ((1262113753210880 / 78598333 : ℚ)) * X ^ 5 + C ((-1890496719909200 / 235794999 : ℚ)) * X ^ 6 + C ((-10230321471065728 / 235794999 : ℚ)) * X ^ 7 + C ((-15015217008647056 / 235794999 : ℚ)) * X ^ 8 + C ((-14874390823794880 / 235794999 : ℚ)) * X ^ 9 + C ((-14226296632771904 / 235794999 : ℚ)) * X ^ 10 + C ((-6148753005520112 / 78598333 : ℚ)) * X ^ 11 + C ((-2060565581849888 / 21435909 : ℚ)) * X ^ 12 + C ((-23946690865689008 / 235794999 : ℚ)) * X ^ 13 + C ((-25986637620401360 / 235794999 : ℚ)) * X ^ 14 + C ((-22818329751565408 / 235794999 : ℚ)) * X ^ 15 + C ((-5522642258196160 / 78598333 : ℚ)) * X ^ 16 + C ((-11880983975753648 / 235794999 : ℚ)) * X ^ 17 + C ((-1457936013119584 / 78598333 : ℚ)) * X ^ 18
theorem CU_013_1_pre_eq :
    CU_0_re_002 * Fplus_dU_re_011 - CU_0_im_002 * Fplus_dU_im_011 = CU_013_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_011, Fplus_dU_im_011, CU_013_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_1_pim_eq :
    CU_0_re_002 * Fplus_dU_im_011 + CU_0_im_002 * Fplus_dU_re_011 = CU_013_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_011, Fplus_dU_im_011, CU_013_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_1_mul :
    CU_0_c_002 * Fplus_dU_c_011 = ofLadj CU_013_1_pre CU_013_1_pim := by
  rw [CU_0_c_002, Fplus_dU_c_011, ofLadj_mul, CU_013_1_pre_eq, CU_013_1_pim_eq]

def CU_013_2_pre : Polynomial ℚ := C ((-5277918908780 / 235794999 : ℚ)) + C ((121142661053008 / 235794999 : ℚ)) * X + C ((258649220943140 / 235794999 : ℚ)) * X ^ 2 + C ((147305063540240 / 78598333 : ℚ)) * X ^ 3 + C ((63967427457652 / 21435909 : ℚ)) * X ^ 4 + C ((910488783919784 / 235794999 : ℚ)) * X ^ 5 + C ((357404625839612 / 78598333 : ℚ)) * X ^ 6 + C ((101828804708456 / 21435909 : ℚ)) * X ^ 7 + C ((1012253491893296 / 235794999 : ℚ)) * X ^ 8 + C ((936408418696156 / 235794999 : ℚ)) * X ^ 9 + C ((878464417746868 / 235794999 : ℚ)) * X ^ 10 + C ((862144724375216 / 235794999 : ℚ)) * X ^ 11 + C ((252440585564620 / 78598333 : ℚ)) * X ^ 12 + C ((677759197753016 / 235794999 : ℚ)) * X ^ 13 + C ((570338301272576 / 235794999 : ℚ)) * X ^ 14 + C ((34393808879368 / 21435909 : ℚ)) * X ^ 15 + C ((212936010192340 / 235794999 : ℚ)) * X ^ 16 + C ((17070305531096 / 78598333 : ℚ)) * X ^ 17 + C ((-1155856123812 / 7145303 : ℚ)) * X ^ 18
def CU_013_2_pim : Polynomial ℚ := C ((-130033557096016 / 235794999 : ℚ)) + C ((-260067114192032 / 235794999 : ℚ)) * X + C ((-107497134958200 / 78598333 : ℚ)) * X ^ 2 + C ((-409301247408688 / 235794999 : ℚ)) * X ^ 3 + C ((-133697803725732 / 78598333 : ℚ)) * X ^ 4 + C ((-282885543800572 / 235794999 : ℚ)) * X ^ 5 + C ((-39912030295176 / 78598333 : ℚ)) * X ^ 6 + C ((104945915942636 / 235794999 : ℚ)) * X ^ 7 + C ((229012828236476 / 235794999 : ℚ)) * X ^ 8 + C ((218116795966544 / 235794999 : ℚ)) * X ^ 9 + C ((167933587841948 / 235794999 : ℚ)) * X ^ 10 + C ((224416440047936 / 235794999 : ℚ)) * X ^ 11 + C ((280899292253924 / 235794999 : ℚ)) * X ^ 12 + C ((97713458270632 / 78598333 : ℚ)) * X ^ 13 + C ((369054185076052 / 235794999 : ℚ)) * X ^ 14 + C ((130887467590116 / 78598333 : ℚ)) * X ^ 15 + C ((112980315073496 / 78598333 : ℚ)) * X ^ 16 + C ((84148818456484 / 78598333 : ℚ)) * X ^ 17 + C ((30750286122684 / 78598333 : ℚ)) * X ^ 18
theorem CU_013_2_pre_eq :
    CU_1_re_011 * Fplus_dV_re_002 - CU_1_im_011 * Fplus_dV_im_002 = CU_013_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_002, Fplus_dV_im_002, CU_013_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_2_pim_eq :
    CU_1_re_011 * Fplus_dV_im_002 + CU_1_im_011 * Fplus_dV_re_002 = CU_013_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_002, Fplus_dV_im_002, CU_013_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_2_mul :
    CU_1_c_011 * Fplus_dV_c_002 = ofLadj CU_013_2_pre CU_013_2_pim := by
  rw [CU_1_c_011, Fplus_dV_c_002, ofLadj_mul, CU_013_2_pre_eq, CU_013_2_pim_eq]

def CU_013_3_pre : Polynomial ℚ := C ((1164938616564608 / 235794999 : ℚ)) + C ((5413885826177920 / 78598333 : ℚ)) * X + C ((32223570101646032 / 235794999 : ℚ)) * X ^ 2 + C ((52808730021171920 / 235794999 : ℚ)) * X ^ 3 + C ((7159630754253616 / 21435909 : ℚ)) * X ^ 4 + C ((8527418433000848 / 21435909 : ℚ)) * X ^ 5 + C ((106107869768415472 / 235794999 : ℚ)) * X ^ 6 + C ((37832514883940240 / 78598333 : ℚ)) * X ^ 7 + C ((108156962119982128 / 235794999 : ℚ)) * X ^ 8 + C ((106934675319176464 / 235794999 : ℚ)) * X ^ 9 + C ((106001463711599600 / 235794999 : ℚ)) * X ^ 10 + C ((104488594652339552 / 235794999 : ℚ)) * X ^ 11 + C ((89759806233065840 / 235794999 : ℚ)) * X ^ 12 + C ((74711105217530432 / 235794999 : ℚ)) * X ^ 13 + C ((55348232098810208 / 235794999 : ℚ)) * X ^ 14 + C ((30524257027446304 / 235794999 : ℚ)) * X ^ 15 + C ((16146214344097520 / 235794999 : ℚ)) * X ^ 16 + C ((31735101972656 / 1948719 : ℚ)) * X ^ 17 + C ((-1405783109194880 / 78598333 : ℚ)) * X ^ 18
def CU_013_3_pim : Polynomial ℚ := C ((-11053261048104512 / 235794999 : ℚ)) + C ((-22106522096209024 / 235794999 : ℚ)) * X + C ((-8644471790146608 / 78598333 : ℚ)) * X ^ 2 + C ((-943557754328240 / 7145303 : ℚ)) * X ^ 3 + C ((-7962767987736864 / 78598333 : ℚ)) * X ^ 4 + C ((-838392068033152 / 21435909 : ℚ)) * X ^ 5 + C ((2724433178980672 / 235794999 : ℚ)) * X ^ 6 + C ((20606448637717040 / 235794999 : ℚ)) * X ^ 7 + C ((10354544156174384 / 78598333 : ℚ)) * X ^ 8 + C ((30887880258126784 / 235794999 : ℚ)) * X ^ 9 + C ((30079249592407040 / 235794999 : ℚ)) * X ^ 10 + C ((3631607229319648 / 21435909 : ℚ)) * X ^ 11 + C ((49816109452625216 / 235794999 : ℚ)) * X ^ 12 + C ((52834372061136272 / 235794999 : ℚ)) * X ^ 13 + C ((19287536791044000 / 78598333 : ℚ)) * X ^ 14 + C ((17042164967237152 / 78598333 : ℚ)) * X ^ 15 + C ((37499291052647584 / 235794999 : ℚ)) * X ^ 16 + C ((8929141821853216 / 78598333 : ℚ)) * X ^ 17 + C ((9944197372605328 / 235794999 : ℚ)) * X ^ 18
theorem CU_013_3_pre_eq :
    CU_1_re_002 * Fplus_dV_re_011 - CU_1_im_002 * Fplus_dV_im_011 = CU_013_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_011, Fplus_dV_im_011, CU_013_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_3_pim_eq :
    CU_1_re_002 * Fplus_dV_im_011 + CU_1_im_002 * Fplus_dV_re_011 = CU_013_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_011, Fplus_dV_im_011, CU_013_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_3_mul :
    CU_1_c_002 * Fplus_dV_c_011 = ofLadj CU_013_3_pre CU_013_3_pim := by
  rw [CU_1_c_002, Fplus_dV_c_011, ofLadj_mul, CU_013_3_pre_eq, CU_013_3_pim_eq]

def CU_013_4_pre : Polynomial ℚ := C ((-4844768106228 / 78598333 : ℚ)) + C ((13020132558396 / 78598333 : ℚ)) * X ^ 2 + C ((30034382667832 / 78598333 : ℚ)) * X ^ 3 + C ((45689790335224 / 78598333 : ℚ)) * X ^ 4 + C ((55000088512568 / 78598333 : ℚ)) * X ^ 5 + C ((55000088512568 / 78598333 : ℚ)) * X ^ 6 + C ((45689790335224 / 78598333 : ℚ)) * X ^ 7 + C ((30034382667832 / 78598333 : ℚ)) * X ^ 8 + C ((13020132558396 / 78598333 : ℚ)) * X ^ 9
def CU_013_4_pim : Polynomial ℚ := C ((-16515653521492 / 78598333 : ℚ)) + C ((-33031307042984 / 78598333 : ℚ)) * X + C ((-44295447204508 / 78598333 : ℚ)) * X ^ 2 + C ((-46732672862468 / 78598333 : ℚ)) * X ^ 3 + C ((-39603837915240 / 78598333 : ℚ)) * X ^ 4 + C ((-25119013248532 / 78598333 : ℚ)) * X ^ 5 + C ((-7912293794452 / 78598333 : ℚ)) * X ^ 6 + C ((6572530872256 / 78598333 : ℚ)) * X ^ 7 + C ((13701365819484 / 78598333 : ℚ)) * X ^ 8 + C ((11264140161524 / 78598333 : ℚ)) * X ^ 9
theorem CU_013_4_pre_eq :
    CU_2_re_011 * Fplus_dW_re_002 - CU_2_im_011 * Fplus_dW_im_002 = CU_013_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_002, Fplus_dW_im_002, CU_013_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_4_pim_eq :
    CU_2_re_011 * Fplus_dW_im_002 + CU_2_im_011 * Fplus_dW_re_002 = CU_013_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_002, Fplus_dW_im_002, CU_013_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_4_mul :
    CU_2_c_011 * Fplus_dW_c_002 = ofLadj CU_013_4_pre CU_013_4_pim := by
  rw [CU_2_c_011, Fplus_dW_c_002, ofLadj_mul, CU_013_4_pre_eq, CU_013_4_pim_eq]

def CU_013_5_pre : Polynomial ℚ := C ((19142653431904 / 235794999 : ℚ)) + C ((-439668093439616 / 235794999 : ℚ)) * X + C ((-312887983036752 / 78598333 : ℚ)) * X ^ 2 + C ((-534725893504096 / 78598333 : ℚ)) * X ^ 3 + C ((-2554076651618144 / 235794999 : ℚ)) * X ^ 4 + C ((-1101545155278192 / 78598333 : ℚ)) * X ^ 5 + C ((-3892001154530288 / 235794999 : ℚ)) * X ^ 6 + C ((-4065871798866656 / 235794999 : ℚ)) * X ^ 7 + C ((-1224732936922224 / 78598333 : ℚ)) * X ^ 8 + C ((-1132905471927920 / 78598333 : ℚ)) * X ^ 9 + C ((-3188500497209360 / 235794999 : ℚ)) * X ^ 10 + C ((-1043107273530464 / 78598333 : ℚ)) * X ^ 11 + C ((-916277467923248 / 78598333 : ℚ)) * X ^ 12 + C ((-820017488891168 / 78598333 : ℚ)) * X ^ 13 + C ((-690007043418128 / 78598333 : ℚ)) * X ^ 14 + C ((-457742881232112 / 78598333 : ℚ)) * X ^ 15 + C ((-257666791850304 / 78598333 : ℚ)) * X ^ 16 + C ((-16875880623200 / 21435909 : ℚ)) * X ^ 17 + C ((46188834517392 / 78598333 : ℚ)) * X ^ 18
def CU_013_5_pim : Polynomial ℚ := C ((471933012637568 / 235794999 : ℚ)) + C ((943866025275136 / 235794999 : ℚ)) * X + C ((1170601699648544 / 235794999 : ℚ)) * X ^ 2 + C ((135068580060160 / 21435909 : ℚ)) * X ^ 3 + C ((1455571416283232 / 235794999 : ℚ)) * X ^ 4 + C ((342262214517024 / 78598333 : ℚ)) * X ^ 5 + C ((434644090095472 / 235794999 : ℚ)) * X ^ 6 + C ((-127056028299472 / 78598333 : ℚ)) * X ^ 7 + C ((-831609081031232 / 235794999 : ℚ)) * X ^ 8 + C ((-791971286523968 / 235794999 : ℚ)) * X ^ 9 + C ((-609696193243072 / 235794999 : ℚ)) * X ^ 10 + C ((-814732761422528 / 235794999 : ℚ)) * X ^ 11 + C ((-339923109867328 / 78598333 : ℚ)) * X ^ 12 + C ((-354743303564832 / 78598333 : ℚ)) * X ^ 13 + C ((-446581599066816 / 78598333 : ℚ)) * X ^ 14 + C ((-475077763019808 / 78598333 : ℚ)) * X ^ 15 + C ((-410172073905472 / 78598333 : ℚ)) * X ^ 16 + C ((-916514009500048 / 235794999 : ℚ)) * X ^ 17 + C ((-334769539895312 / 235794999 : ℚ)) * X ^ 18
theorem CU_013_5_pre_eq :
    CU_2_re_002 * Fplus_dW_re_011 - CU_2_im_002 * Fplus_dW_im_011 = CU_013_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_011, Fplus_dW_im_011, CU_013_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_5_pim_eq :
    CU_2_re_002 * Fplus_dW_im_011 + CU_2_im_002 * Fplus_dW_re_011 = CU_013_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_011, Fplus_dW_im_011, CU_013_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_013_5_mul :
    CU_2_c_002 * Fplus_dW_c_011 = ofLadj CU_013_5_pre CU_013_5_pim := by
  rw [CU_2_c_002, Fplus_dW_c_011, ofLadj_mul, CU_013_5_pre_eq, CU_013_5_pim_eq]

@[expose] public def CU_coeff_013 : Ki := CU_0_c_011 * Fplus_dU_c_002 + CU_0_c_002 * Fplus_dU_c_011 + CU_1_c_011 * Fplus_dV_c_002 + CU_1_c_002 * Fplus_dV_c_011 + CU_2_c_011 * Fplus_dW_c_002 + CU_2_c_002 * Fplus_dW_c_011

theorem CU_coeff_013_sum :
    CU_coeff_013 = ofLadj (CU_013_0_pre + CU_013_1_pre + CU_013_2_pre + CU_013_3_pre + CU_013_4_pre + CU_013_5_pre) (CU_013_0_pim + CU_013_1_pim + CU_013_2_pim + CU_013_3_pim + CU_013_4_pim + CU_013_5_pim) := by
  simp only [CU_coeff_013, CU_013_0_mul, CU_013_1_mul, CU_013_2_mul, CU_013_3_mul, CU_013_4_mul, CU_013_5_mul]
  simpa [add_assoc] using ofLadj_add6 CU_013_0_pre CU_013_0_pim CU_013_1_pre CU_013_1_pim CU_013_2_pre CU_013_2_pim CU_013_3_pre CU_013_3_pim CU_013_4_pre CU_013_4_pim CU_013_5_pre CU_013_5_pim

def CU_013_qre : Polynomial ℚ := C ((218424840419680 / 78598333 : ℚ)) + C ((776327517244976 / 21435909 : ℚ)) * X + C ((8662846564018280 / 235794999 : ℚ)) * X ^ 2 + C ((1025587230484504 / 21435909 : ℚ)) * X ^ 3 + C ((4785691952955828 / 78598333 : ℚ)) * X ^ 4 + C ((8307243921711884 / 235794999 : ℚ)) * X ^ 5 + C ((6972331367593052 / 235794999 : ℚ)) * X ^ 6 + C ((4645662096351424 / 235794999 : ℚ)) * X ^ 7 + C ((-883182954966596 / 78598333 : ℚ)) * X ^ 8
def CU_013_qim : Polynomial ℚ := C ((-6270863670318196 / 235794999 : ℚ)) + C ((-6270863670318196 / 235794999 : ℚ)) * X + C ((-2064518479632908 / 235794999 : ℚ)) * X ^ 2 + C ((-3214764094549384 / 235794999 : ℚ)) * X ^ 3 + C ((3939442378236784 / 235794999 : ℚ)) * X ^ 4 + C ((8032590731600156 / 235794999 : ℚ)) * X ^ 5 + C ((2148810127914836 / 78598333 : ℚ)) * X ^ 6 + C ((3330239375373364 / 78598333 : ℚ)) * X ^ 7 + C ((5943571225772332 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_013_poly_re :
    CU_013_0_pre + CU_013_1_pre + CU_013_2_pre + CU_013_3_pre + CU_013_4_pre + CU_013_5_pre = (0 : Polynomial ℚ) + Phi11 * CU_013_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_013_0_pre, CU_013_1_pre, CU_013_2_pre, CU_013_3_pre, CU_013_4_pre, CU_013_5_pre, CU_013_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_013_poly_im :
    CU_013_0_pim + CU_013_1_pim + CU_013_2_pim + CU_013_3_pim + CU_013_4_pim + CU_013_5_pim = (0 : Polynomial ℚ) + Phi11 * CU_013_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_013_0_pim, CU_013_1_pim, CU_013_2_pim, CU_013_3_pim, CU_013_4_pim, CU_013_5_pim, CU_013_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_013_eq :
    CU_coeff_013 = (0 : Ki) := by
  rw [CU_coeff_013_sum, CU_coeff_013_poly_re,
    CU_coeff_013_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
