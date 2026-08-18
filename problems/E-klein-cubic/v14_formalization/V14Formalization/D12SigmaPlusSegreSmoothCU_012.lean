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

def CU_012_0_pre : Polynomial ℚ := C ((-28067922095632 / 235794999 : ℚ)) + C ((-457761279463264 / 235794999 : ℚ)) * X + C ((-304661660652540 / 78598333 : ℚ)) * X ^ 2 + C ((-1483543233641074 / 235794999 : ℚ)) * X ^ 3 + C ((-2254435729179454 / 235794999 : ℚ)) * X ^ 4 + C ((-2725682108627230 / 235794999 : ℚ)) * X ^ 5 + C ((-286801315111600 / 21435909 : ℚ)) * X ^ 6 + C ((-1147077331449244 / 78598333 : ℚ)) * X ^ 7 + C ((-1127879705306282 / 78598333 : ℚ)) * X ^ 8 + C ((-3429027972680974 / 235794999 : ℚ)) * X ^ 9 + C ((-3463727022568036 / 235794999 : ℚ)) * X ^ 10 + C ((-3448583809475236 / 235794999 : ℚ)) * X ^ 11 + C ((-1001988581034924 / 78598333 : ℚ)) * X ^ 12 + C ((-2515042990723354 / 235794999 : ℚ)) * X ^ 13 + C ((-1900095882277772 / 235794999 : ℚ)) * X ^ 14 + C ((-1087463108862314 / 235794999 : ℚ)) * X ^ 15 + C ((-591397855001524 / 235794999 : ℚ)) * X ^ 16 + C ((-54088499133718 / 78598333 : ℚ)) * X ^ 17 + C ((33111052101988 / 78598333 : ℚ)) * X ^ 18
def CU_012_0_pim : Polynomial ℚ := C ((109288124675300 / 78598333 : ℚ)) + C ((218576249350600 / 78598333 : ℚ)) * X + C ((799077149539960 / 235794999 : ℚ)) * X ^ 2 + C ((998004481653134 / 235794999 : ℚ)) * X ^ 3 + C ((867432828467726 / 235794999 : ℚ)) * X ^ 4 + C ((521692261881794 / 235794999 : ℚ)) * X ^ 5 + C ((254397422230484 / 235794999 : ℚ)) * X ^ 6 + C ((-226412573055136 / 235794999 : ℚ)) * X ^ 7 + C ((-504474378388538 / 235794999 : ℚ)) * X ^ 8 + C ((-15484449187814 / 7145303 : ℚ)) * X ^ 9 + C ((-541025886167900 / 235794999 : ℚ)) * X ^ 10 + C ((-912923773426432 / 235794999 : ℚ)) * X ^ 11 + C ((-428273886894988 / 78598333 : ℚ)) * X ^ 12 + C ((-486069708381054 / 78598333 : ℚ)) * X ^ 13 + C ((-1663648902065660 / 235794999 : ℚ)) * X ^ 14 + C ((-504682072614318 / 78598333 : ℚ)) * X ^ 15 + C ((-376564623768308 / 78598333 : ℚ)) * X ^ 16 + C ((-272171537202806 / 78598333 : ℚ)) * X ^ 17 + C ((-99030945456900 / 78598333 : ℚ)) * X ^ 18
theorem CU_012_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_002 - CU_0_im_010 * Fplus_dU_im_002 = CU_012_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_002, Fplus_dU_im_002, CU_012_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_002 + CU_0_im_010 * Fplus_dU_re_002 = CU_012_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_002, Fplus_dU_im_002, CU_012_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_0_mul :
    CU_0_c_010 * Fplus_dU_c_002 = ofLadj CU_012_0_pre CU_012_0_pim := by
  rw [CU_0_c_010, Fplus_dU_c_002, ofLadj_mul, CU_012_0_pre_eq, CU_012_0_pim_eq]

def CU_012_1_pre : Polynomial ℚ := C ((235152936259664 / 235794999 : ℚ)) + C ((3182632231511360 / 235794999 : ℚ)) * X + C ((2158406979651600 / 78598333 : ℚ)) * X ^ 2 + C ((10643928723314336 / 235794999 : ℚ)) * X ^ 3 + C ((15845488823694824 / 235794999 : ℚ)) * X ^ 4 + C ((18829802296380712 / 235794999 : ℚ)) * X ^ 5 + C ((21234330271455568 / 235794999 : ℚ)) * X ^ 6 + C ((22553912781713516 / 235794999 : ℚ)) * X ^ 7 + C ((21486596324542576 / 235794999 : ℚ)) * X ^ 8 + C ((21080486081369464 / 235794999 : ℚ)) * X ^ 9 + C ((20770283868933532 / 235794999 : ℚ)) * X ^ 10 + C ((20419415108098912 / 235794999 : ℚ)) * X ^ 11 + C ((17587651637422172 / 235794999 : ℚ)) * X ^ 12 + C ((14605265142414664 / 235794999 : ℚ)) * X ^ 13 + C ((10842667601228240 / 235794999 : ℚ)) * X ^ 14 + C ((2004789557061260 / 78598333 : ℚ)) * X ^ 15 + C ((3252043880552392 / 235794999 : ℚ)) * X ^ 16 + C ((847515905477536 / 235794999 : ℚ)) * X ^ 17 + C ((-231351762278304 / 78598333 : ℚ)) * X ^ 18
def CU_012_1_pim : Polynomial ℚ := C ((-714374379860352 / 78598333 : ℚ)) + C ((-1428748759720704 / 78598333 : ℚ)) * X + C ((-5086375500615800 / 235794999 : ℚ)) * X ^ 2 + C ((-1996817083834184 / 78598333 : ℚ)) * X ^ 3 + C ((-4505392276944808 / 235794999 : ℚ)) * X ^ 4 + C ((-1569455067165320 / 235794999 : ℚ)) * X ^ 5 + C ((784336268460664 / 235794999 : ℚ)) * X ^ 6 + C ((4242890354942876 / 235794999 : ℚ)) * X ^ 7 + C ((6226512799286392 / 235794999 : ℚ)) * X ^ 8 + C ((6168151385358704 / 235794999 : ℚ)) * X ^ 9 + C ((1966502384809932 / 78598333 : ℚ)) * X ^ 10 + C ((2549597209691856 / 78598333 : ℚ)) * X ^ 11 + C ((3132692034573780 / 78598333 : ℚ)) * X ^ 12 + C ((3309853698082040 / 78598333 : ℚ)) * X ^ 13 + C ((10775275431205184 / 235794999 : ℚ)) * X ^ 14 + C ((9460592918141428 / 235794999 : ℚ)) * X ^ 15 + C ((624533481110912 / 21435909 : ℚ)) * X ^ 16 + C ((1642195828491216 / 78598333 : ℚ)) * X ^ 17 + C ((1813245982849528 / 235794999 : ℚ)) * X ^ 18
theorem CU_012_1_pre_eq :
    CU_0_re_001 * Fplus_dU_re_011 - CU_0_im_001 * Fplus_dU_im_011 = CU_012_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_011, Fplus_dU_im_011, CU_012_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_1_pim_eq :
    CU_0_re_001 * Fplus_dU_im_011 + CU_0_im_001 * Fplus_dU_re_011 = CU_012_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_011, Fplus_dU_im_011, CU_012_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_1_mul :
    CU_0_c_001 * Fplus_dU_c_011 = ofLadj CU_012_1_pre CU_012_1_pim := by
  rw [CU_0_c_001, Fplus_dU_c_011, ofLadj_mul, CU_012_1_pre_eq, CU_012_1_pim_eq]

def CU_012_2_pre : Polynomial ℚ := C ((811733112406 / 78598333 : ℚ)) + C ((-55306984964312 / 235794999 : ℚ)) * X + C ((-118065381311726 / 235794999 : ℚ)) * X ^ 2 + C ((-201586407075710 / 235794999 : ℚ)) * X ^ 3 + C ((-107022959247392 / 78598333 : ℚ)) * X ^ 4 + C ((-415530062375254 / 235794999 : ℚ)) * X ^ 5 + C ((-489229677400612 / 235794999 : ℚ)) * X ^ 6 + C ((-170353601859858 / 78598333 : ℚ)) * X ^ 7 + C ((-461905134102314 / 235794999 : ℚ)) * X ^ 8 + C ((-427355177419180 / 235794999 : ℚ)) * X ^ 9 + C ((-36444185724964 / 21435909 : ℚ)) * X ^ 10 + C ((-393426921831496 / 235794999 : ℚ)) * X ^ 11 + C ((-115193019336764 / 78598333 : ℚ)) * X ^ 12 + C ((-309289796107454 / 235794999 : ℚ)) * X ^ 13 + C ((-86772909008868 / 78598333 : ℚ)) * X ^ 14 + C ((-172631051309170 / 235794999 : ℚ)) * X ^ 15 + C ((-32379267679532 / 78598333 : ℚ)) * X ^ 16 + C ((-7812729337746 / 78598333 : ℚ)) * X ^ 17 + C ((17360876528228 / 235794999 : ℚ)) * X ^ 18
def CU_012_2_pim : Polynomial ℚ := C ((59372471358886 / 235794999 : ℚ)) + C ((118744942717772 / 235794999 : ℚ)) * X + C ((147154617273650 / 235794999 : ℚ)) * X ^ 2 + C ((186794257016522 / 235794999 : ℚ)) * X ^ 3 + C ((61053602685492 / 78598333 : ℚ)) * X ^ 4 + C ((129145705866142 / 235794999 : ℚ)) * X ^ 5 + C ((54671217134836 / 235794999 : ℚ)) * X ^ 6 + C ((-15917028795678 / 78598333 : ℚ)) * X ^ 7 + C ((-104312963465338 / 235794999 : ℚ)) * X ^ 8 + C ((-99367411357868 / 235794999 : ℚ)) * X ^ 9 + C ((-25506237806440 / 78598333 : ℚ)) * X ^ 10 + C ((-102296861501396 / 235794999 : ℚ)) * X ^ 11 + C ((-128075009583472 / 235794999 : ℚ)) * X ^ 12 + C ((-133635986200802 / 235794999 : ℚ)) * X ^ 13 + C ((-56110024612068 / 78598333 : ℚ)) * X ^ 14 + C ((-59718673945402 / 78598333 : ℚ)) * X ^ 15 + C ((-51518788846616 / 78598333 : ℚ)) * X ^ 16 + C ((-115109336746150 / 235794999 : ℚ)) * X ^ 17 + C ((-42102480118256 / 235794999 : ℚ)) * X ^ 18
theorem CU_012_2_pre_eq :
    CU_1_re_010 * Fplus_dV_re_002 - CU_1_im_010 * Fplus_dV_im_002 = CU_012_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_002, Fplus_dV_im_002, CU_012_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_2_pim_eq :
    CU_1_re_010 * Fplus_dV_im_002 + CU_1_im_010 * Fplus_dV_re_002 = CU_012_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_002, Fplus_dV_im_002, CU_012_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_2_mul :
    CU_1_c_010 * Fplus_dV_c_002 = ofLadj CU_012_2_pre CU_012_2_pim := by
  rw [CU_1_c_010, Fplus_dV_c_002, ofLadj_mul, CU_012_2_pre_eq, CU_012_2_pim_eq]

def CU_012_3_pre : Polynomial ℚ := C ((-145448108140976 / 78598333 : ℚ)) + C ((-2028301315751424 / 78598333 : ℚ)) * X + C ((-12072320660026472 / 235794999 : ℚ)) * X ^ 2 + C ((-19784842241586728 / 235794999 : ℚ)) * X ^ 3 + C ((-29505966984028312 / 235794999 : ℚ)) * X ^ 4 + C ((-35142464145936380 / 235794999 : ℚ)) * X ^ 5 + C ((-39753484458910880 / 235794999 : ℚ)) * X ^ 6 + C ((-14173917135252748 / 78598333 : ℚ)) * X ^ 7 + C ((-13506943212852036 / 78598333 : ℚ)) * X ^ 8 + C ((-40062886180542284 / 235794999 : ℚ)) * X ^ 9 + C ((-39713279497385312 / 235794999 : ℚ)) * X ^ 10 + C ((-3558775270486016 / 21435909 : ℚ)) * X ^ 11 + C ((-33628375550131040 / 235794999 : ℚ)) * X ^ 12 + C ((-9330188506838604 / 78598333 : ℚ)) * X ^ 13 + C ((-20735987396969380 / 235794999 : ℚ)) * X ^ 14 + C ((-11435658306916396 / 235794999 : ℚ)) * X ^ 15 + C ((-6049319528026880 / 235794999 : ℚ)) * X ^ 16 + C ((-1438299215052380 / 235794999 : ℚ)) * X ^ 17 + C ((1580126114813536 / 235794999 : ℚ)) * X ^ 18
def CU_012_3_pim : Polynomial ℚ := C ((1380373982202416 / 78598333 : ℚ)) + C ((2760747964404832 / 78598333 : ℚ)) * X + C ((9716003359052896 / 235794999 : ℚ)) * X ^ 2 + C ((11665952218297088 / 235794999 : ℚ)) * X ^ 3 + C ((8949571286974696 / 235794999 : ℚ)) * X ^ 4 + C ((1151776575584092 / 78598333 : ℚ)) * X ^ 5 + C ((-92778205784552 / 21435909 : ℚ)) * X ^ 6 + C ((-7720348224519556 / 235794999 : ℚ)) * X ^ 7 + C ((-3879326005960316 / 78598333 : ℚ)) * X ^ 8 + C ((-11572115850221044 / 235794999 : ℚ)) * X ^ 9 + C ((-11269193456977136 / 235794999 : ℚ)) * X ^ 10 + C ((-41229740287280 / 649573 : ℚ)) * X ^ 11 + C ((-18663597991588144 / 235794999 : ℚ)) * X ^ 12 + C ((-599831365581292 / 7145303 : ℚ)) * X ^ 13 + C ((-21678521755766924 / 235794999 : ℚ)) * X ^ 14 + C ((-19154344643035852 / 235794999 : ℚ)) * X ^ 15 + C ((-14049248063994392 / 235794999 : ℚ)) * X ^ 16 + C ((-3345356318159532 / 78598333 : ℚ)) * X ^ 17 + C ((-3725425974770072 / 235794999 : ℚ)) * X ^ 18
theorem CU_012_3_pre_eq :
    CU_1_re_001 * Fplus_dV_re_011 - CU_1_im_001 * Fplus_dV_im_011 = CU_012_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_011, Fplus_dV_im_011, CU_012_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_3_pim_eq :
    CU_1_re_001 * Fplus_dV_im_011 + CU_1_im_001 * Fplus_dV_re_011 = CU_012_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_011, Fplus_dV_im_011, CU_012_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_3_mul :
    CU_1_c_001 * Fplus_dV_c_011 = ofLadj CU_012_3_pre CU_012_3_pim := by
  rw [CU_1_c_001, Fplus_dV_c_011, ofLadj_mul, CU_012_3_pre_eq, CU_012_3_pim_eq]

def CU_012_4_pre : Polynomial ℚ := C ((1975858919006 / 78598333 : ℚ)) + C ((-5360875097362 / 78598333 : ℚ)) * X ^ 2 + C ((-12407594525080 / 78598333 : ℚ)) * X ^ 3 + C ((-18878611840658 / 78598333 : ℚ)) * X ^ 4 + C ((-22692443156844 / 78598333 : ℚ)) * X ^ 5 + C ((-22692443156844 / 78598333 : ℚ)) * X ^ 6 + C ((-18878611840658 / 78598333 : ℚ)) * X ^ 7 + C ((-12407594525080 / 78598333 : ℚ)) * X ^ 8 + C ((-5360875097362 / 78598333 : ℚ)) * X ^ 9
def CU_012_4_pim : Polynomial ℚ := C ((6797723724074 / 78598333 : ℚ)) + C ((13595447448148 / 78598333 : ℚ)) * X + C ((18269714240458 / 78598333 : ℚ)) * X ^ 2 + C ((19285972488660 / 78598333 : ℚ)) * X ^ 3 + C ((16318304456574 / 78598333 : ℚ)) * X ^ 4 + C ((10333342722768 / 78598333 : ℚ)) * X ^ 5 + C ((3262104725380 / 78598333 : ℚ)) * X ^ 6 + C ((-2722857008426 / 78598333 : ℚ)) * X ^ 7 + C ((-5690525040512 / 78598333 : ℚ)) * X ^ 8 + C ((-4674266792310 / 78598333 : ℚ)) * X ^ 9
theorem CU_012_4_pre_eq :
    CU_2_re_010 * Fplus_dW_re_002 - CU_2_im_010 * Fplus_dW_im_002 = CU_012_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_002, Fplus_dW_im_002, CU_012_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_4_pim_eq :
    CU_2_re_010 * Fplus_dW_im_002 + CU_2_im_010 * Fplus_dW_re_002 = CU_012_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_002, Fplus_dW_im_002, CU_012_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_4_mul :
    CU_2_c_010 * Fplus_dW_c_002 = ofLadj CU_012_4_pre CU_012_4_pim := by
  rw [CU_2_c_010, Fplus_dW_c_002, ofLadj_mul, CU_012_4_pre_eq, CU_012_4_pim_eq]

def CU_012_5_pre : Polynomial ℚ := C ((-4992888049432 / 235794999 : ℚ)) + C ((38345094102624 / 78598333 : ℚ)) * X + C ((245586924215848 / 235794999 : ℚ)) * X ^ 2 + C ((139964514383648 / 78598333 : ℚ)) * X ^ 3 + C ((60766573299320 / 21435909 : ℚ)) * X ^ 4 + C ((864752098164476 / 235794999 : ℚ)) * X ^ 5 + C ((1018613914444748 / 235794999 : ℚ)) * X ^ 6 + C ((1064129430108232 / 235794999 : ℚ)) * X ^ 7 + C ((320517075555340 / 78598333 : ℚ)) * X ^ 8 + C ((889374936548212 / 235794999 : ℚ)) * X ^ 9 + C ((834403895256676 / 235794999 : ℚ)) * X ^ 10 + C ((818939237310512 / 235794999 : ℚ)) * X ^ 11 + C ((719368612948804 / 235794999 : ℚ)) * X ^ 12 + C ((214596004110788 / 78598333 : ℚ)) * X ^ 13 + C ((180552561171692 / 78598333 : ℚ)) * X ^ 14 + C ((119793021022352 / 78598333 : ℚ)) * X ^ 15 + C ((202339488750920 / 235794999 : ℚ)) * X ^ 16 + C ((48477672470648 / 235794999 : ℚ)) * X ^ 17 + C ((-12106020249552 / 78598333 : ℚ)) * X ^ 18
def CU_012_5_pim : Polynomial ℚ := C ((-123473209464472 / 235794999 : ℚ)) + C ((-246946418928944 / 235794999 : ℚ)) * X + C ((-306363595052632 / 235794999 : ℚ)) * X ^ 2 + C ((-129614276963456 / 78598333 : ℚ)) * X ^ 3 + C ((-380778788833160 / 235794999 : ℚ)) * X ^ 4 + C ((-89559695088132 / 78598333 : ℚ)) * X ^ 5 + C ((-113738440995700 / 235794999 : ℚ)) * X ^ 6 + C ((99892548517120 / 235794999 : ℚ)) * X ^ 7 + C ((72610852394644 / 78598333 : ℚ)) * X ^ 8 + C ((69140303981476 / 78598333 : ℚ)) * X ^ 9 + C ((159658885800580 / 235794999 : ℚ)) * X ^ 10 + C ((213320799168328 / 235794999 : ℚ)) * X ^ 11 + C ((266982712536076 / 235794999 : ℚ)) * X ^ 12 + C ((278637862515916 / 235794999 : ℚ)) * X ^ 13 + C ((10627437973156 / 7145303 : ℚ)) * X ^ 14 + C ((372994839291080 / 235794999 : ℚ)) * X ^ 15 + C ((29286985183976 / 21435909 : ℚ)) * X ^ 16 + C ((79985289548024 / 78598333 : ℚ)) * X ^ 17 + C ((87586580432672 / 235794999 : ℚ)) * X ^ 18
theorem CU_012_5_pre_eq :
    CU_2_re_001 * Fplus_dW_re_011 - CU_2_im_001 * Fplus_dW_im_011 = CU_012_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_011, Fplus_dW_im_011, CU_012_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_5_pim_eq :
    CU_2_re_001 * Fplus_dW_im_011 + CU_2_im_001 * Fplus_dW_re_011 = CU_012_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_011, Fplus_dW_im_011, CU_012_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_5_mul :
    CU_2_c_001 * Fplus_dW_c_011 = ofLadj CU_012_5_pre CU_012_5_pim := by
  rw [CU_2_c_001, Fplus_dW_c_011, ofLadj_mul, CU_012_5_pre_eq, CU_012_5_pim_eq]

def CU_012_6_pre : Polynomial ℚ := C ((86938930904 / 7145303 : ℚ)) + C ((-701260065536 / 21435909 : ℚ)) * X ^ 2 + C ((-146741138792 / 1948719 : ℚ)) * X ^ 3 + C ((-818599073216 / 7145303 : ℚ)) * X ^ 4 + C ((-2957611828168 / 21435909 : ℚ)) * X ^ 5 + C ((-2957611828168 / 21435909 : ℚ)) * X ^ 6 + C ((-818599073216 / 7145303 : ℚ)) * X ^ 7 + C ((-146741138792 / 1948719 : ℚ)) * X ^ 8 + C ((-701260065536 / 21435909 : ℚ)) * X ^ 9
def CU_012_6_pim : Polynomial ℚ := C ((9776300513864 / 235794999 : ℚ)) + C ((19552601027728 / 235794999 : ℚ)) * X + C ((8734676503712 / 78598333 : ℚ)) * X ^ 2 + C ((27633038975672 / 235794999 : ℚ)) * X ^ 3 + C ((23438337857872 / 235794999 : ℚ)) * X ^ 4 + C ((14867586022616 / 235794999 : ℚ)) * X ^ 5 + C ((4685015005112 / 235794999 : ℚ)) * X ^ 6 + C ((-1295245610048 / 78598333 : ℚ)) * X ^ 7 + C ((-8080437947944 / 235794999 : ℚ)) * X ^ 8 + C ((-6651428483408 / 235794999 : ℚ)) * X ^ 9
theorem CU_012_6_neg_re : -CU_3_re_012 = CU_012_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_012, CU_012_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_6_neg_im : -CU_3_im_012 = CU_012_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_012, CU_012_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_012_6_mul : -CU_3_c_012 = ofLadj CU_012_6_pre CU_012_6_pim := by
  rw [CU_3_c_012, ofLadj_neg, CU_012_6_neg_re, CU_012_6_neg_im]

@[expose] public def CU_coeff_012 : Ki := CU_0_c_010 * Fplus_dU_c_002 + CU_0_c_001 * Fplus_dU_c_011 + CU_1_c_010 * Fplus_dV_c_002 + CU_1_c_001 * Fplus_dV_c_011 + CU_2_c_010 * Fplus_dW_c_002 + CU_2_c_001 * Fplus_dW_c_011 + (-CU_3_c_012)

theorem CU_coeff_012_sum :
    CU_coeff_012 = ofLadj (CU_012_0_pre + CU_012_1_pre + CU_012_2_pre + CU_012_3_pre + CU_012_4_pre + CU_012_5_pre + CU_012_6_pre) (CU_012_0_pim + CU_012_1_pim + CU_012_2_pim + CU_012_3_pim + CU_012_4_pim + CU_012_5_pim + CU_012_6_pim) := by
  simp only [CU_coeff_012, CU_012_0_mul, CU_012_1_mul, CU_012_2_mul, CU_012_3_mul, CU_012_4_mul, CU_012_5_mul, CU_012_6_mul]
  simp [ofLadj_add, add_assoc]

def CU_012_qre : Polynomial ℚ := C ((-74340145831420 / 78598333 : ℚ)) + C ((-3077284260368356 / 235794999 : ℚ)) * X + C ((-1035684982758512 / 78598333 : ℚ)) * X ^ 2 + C ((-4053768431069152 / 235794999 : ℚ)) * X ^ 3 + C ((-1730023996231132 / 78598333 : ℚ)) * X ^ 4 + C ((-3038532916073356 / 235794999 : ℚ)) * X ^ 5 + C ((-232314772204100 / 21435909 : ℚ)) * X ^ 6 + C ((-1694456122582748 / 235794999 : ℚ)) * X ^ 7 + C ((322148933354720 / 78598333 : ℚ)) * X ^ 8
def CU_012_qim : Polynomial ℚ := C ((2291931914632592 / 235794999 : ℚ)) + C ((2291931914632592 / 235794999 : ℚ)) * X + C ((255548457721800 / 78598333 : ℚ)) * X ^ 2 + C ((1206438628584892 / 235794999 : ℚ)) * X ^ 3 + C ((-1370560722066952 / 235794999 : ℚ)) * X ^ 4 + C ((-2872485952687108 / 235794999 : ℚ)) * X ^ 5 + C ((-2340323623879952 / 235794999 : ℚ)) * X ^ 6 + C ((-1212453606912872 / 78598333 : ℚ)) * X ^ 7 + C ((-2163788727976828 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_012_poly_re :
    CU_012_0_pre + CU_012_1_pre + CU_012_2_pre + CU_012_3_pre + CU_012_4_pre + CU_012_5_pre + CU_012_6_pre = (0 : Polynomial ℚ) + Phi11 * CU_012_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_012_0_pre, CU_012_1_pre, CU_012_2_pre, CU_012_3_pre, CU_012_4_pre, CU_012_5_pre, CU_012_6_pre, CU_012_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_012_poly_im :
    CU_012_0_pim + CU_012_1_pim + CU_012_2_pim + CU_012_3_pim + CU_012_4_pim + CU_012_5_pim + CU_012_6_pim = (0 : Polynomial ℚ) + Phi11 * CU_012_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_012_0_pim, CU_012_1_pim, CU_012_2_pim, CU_012_3_pim, CU_012_4_pim, CU_012_5_pim, CU_012_6_pim, CU_012_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_012_eq :
    CU_coeff_012 = (0 : Ki) := by
  rw [CU_coeff_012_sum, CU_coeff_012_poly_re,
    CU_coeff_012_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
