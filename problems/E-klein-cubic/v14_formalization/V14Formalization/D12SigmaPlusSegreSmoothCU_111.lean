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

def CU_111_0_pre : Polynomial ℚ := C ((73207338476048 / 235794999 : ℚ)) + C ((523155747958016 / 235794999 : ℚ)) * X + C ((986254429705528 / 235794999 : ℚ)) * X ^ 2 + C ((1550629459356920 / 235794999 : ℚ)) * X ^ 3 + C ((200699378613032 / 21435909 : ℚ)) * X ^ 4 + C ((2530935542376400 / 235794999 : ℚ)) * X ^ 5 + C ((2770274147137448 / 235794999 : ℚ)) * X ^ 6 + C ((2881890283126988 / 235794999 : ℚ)) * X ^ 7 + C ((2669797699676996 / 235794999 : ℚ)) * X ^ 8 + C ((2629308542388008 / 235794999 : ℚ)) * X ^ 9 + C ((2598434932277308 / 235794999 : ℚ)) * X ^ 10 + C ((837903981905928 / 78598333 : ℚ)) * X ^ 11 + C ((2075279184319292 / 235794999 : ℚ)) * X ^ 12 + C ((1643054112682480 / 235794999 : ℚ)) * X ^ 13 + C ((373056080106692 / 78598333 : ℚ)) * X ^ 14 + C ((499288387720876 / 235794999 : ℚ)) * X ^ 15 + C ((198132449009104 / 235794999 : ℚ)) * X ^ 16 + C ((-13735385250648 / 78598333 : ℚ)) * X ^ 17 + C ((-58302910220920 / 78598333 : ℚ)) * X ^ 18
def CU_111_0_pim : Polynomial ℚ := C ((-78190379275520 / 78598333 : ℚ)) + C ((-156380758551040 / 78598333 : ℚ)) * X + C ((-446170642154792 / 235794999 : ℚ)) * X ^ 2 + C ((-444680421531100 / 235794999 : ℚ)) * X ^ 3 + C ((-121365830685200 / 235794999 : ℚ)) * X ^ 4 + C ((380677348693504 / 235794999 : ℚ)) * X ^ 5 + C ((764880113363744 / 235794999 : ℚ)) * X ^ 6 + C ((1253956836859256 / 235794999 : ℚ)) * X ^ 7 + C ((1525199980741552 / 235794999 : ℚ)) * X ^ 8 + C ((1519367174522356 / 235794999 : ℚ)) * X ^ 9 + C ((1492586090747528 / 235794999 : ℚ)) * X ^ 10 + C ((1687944073364192 / 235794999 : ℚ)) * X ^ 11 + C ((1883302055980856 / 235794999 : ℚ)) * X ^ 12 + C ((1833549338707700 / 235794999 : ℚ)) * X ^ 13 + C ((166020573805892 / 21435909 : ℚ)) * X ^ 14 + C ((1519920967686784 / 235794999 : ℚ)) * X ^ 15 + C ((95659904365508 / 21435909 : ℚ)) * X ^ 16 + C ((1952973721756 / 649573 : ℚ)) * X ^ 17 + C ((84744632404808 / 78598333 : ℚ)) * X ^ 18
theorem CU_111_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_101 - CU_0_im_010 * Fplus_dU_im_101 = CU_111_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_111_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_101 + CU_0_im_010 * Fplus_dU_re_101 = CU_111_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_111_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_0_mul :
    CU_0_c_010 * Fplus_dU_c_101 = ofLadj CU_111_0_pre CU_111_0_pim := by
  rw [CU_0_c_010_def, Fplus_dU_c_101_def, ofLadj_mul, CU_111_0_pre_eq, CU_111_0_pim_eq]

def CU_111_1_pre : Polynomial ℚ := C ((-4349048896400 / 235794999 : ℚ)) + C ((636526446302272 / 235794999 : ℚ)) * X + C ((424299980856820 / 78598333 : ℚ)) * X ^ 2 + C ((2074907644792412 / 235794999 : ℚ)) * X ^ 3 + C ((3507395806780676 / 235794999 : ℚ)) * X ^ 4 + C ((4489938043681280 / 235794999 : ℚ)) * X ^ 5 + C ((5415279598326628 / 235794999 : ℚ)) * X ^ 6 + C ((1939257808673120 / 78598333 : ℚ)) * X ^ 7 + C ((1805010112313328 / 78598333 : ℚ)) * X ^ 8 + C ((1709000944892664 / 78598333 : ℚ)) * X ^ 9 + C ((1635689965099796 / 78598333 : ℚ)) * X ^ 10 + C ((4829505877508552 / 235794999 : ℚ)) * X ^ 11 + C ((4270543448997116 / 235794999 : ℚ)) * X ^ 12 + C ((1284700964035844 / 78598333 : ℚ)) * X ^ 13 + C ((3340122692147572 / 235794999 : ℚ)) * X ^ 14 + C ((197487182861288 / 21435909 : ℚ)) * X ^ 15 + C ((449030047647532 / 78598333 : ℚ)) * X ^ 16 + C ((421748588297248 / 235794999 : ℚ)) * X ^ 17 + C ((-46006202588172 / 78598333 : ℚ)) * X ^ 18
def CU_111_1_pim : Polynomial ℚ := C ((-603669400649336 / 235794999 : ℚ)) + C ((-1207338801298672 / 235794999 : ℚ)) * X + C ((-1560925176498592 / 235794999 : ℚ)) * X ^ 2 + C ((-2141186047086872 / 235794999 : ℚ)) * X ^ 3 + C ((-717747759290340 / 78598333 : ℚ)) * X ^ 4 + C ((-1581551832474964 / 235794999 : ℚ)) * X ^ 5 + C ((-947871165039748 / 235794999 : ℚ)) * X ^ 6 + C ((268186573634548 / 235794999 : ℚ)) * X ^ 7 + C ((7669776123392 / 1948719 : ℚ)) * X ^ 8 + C ((886644079145108 / 235794999 : ℚ)) * X ^ 9 + C ((696039733253192 / 235794999 : ℚ)) * X ^ 10 + C ((1020537168773296 / 235794999 : ℚ)) * X ^ 11 + C ((448344868097800 / 78598333 : ℚ)) * X ^ 12 + C ((502672211200468 / 78598333 : ℚ)) * X ^ 13 + C ((2046878672404360 / 235794999 : ℚ)) * X ^ 14 + C ((726605096896528 / 78598333 : ℚ)) * X ^ 15 + C ((617654771275404 / 78598333 : ℚ)) * X ^ 16 + C ((503398073312140 / 78598333 : ℚ)) * X ^ 17 + C ((179658983264936 / 78598333 : ℚ)) * X ^ 18
theorem CU_111_1_pre_eq :
    CU_0_re_001 * Fplus_dU_re_110 - CU_0_im_001 * Fplus_dU_im_110 = CU_111_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_111_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_1_pim_eq :
    CU_0_re_001 * Fplus_dU_im_110 + CU_0_im_001 * Fplus_dU_re_110 = CU_111_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_111_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_1_mul :
    CU_0_c_001 * Fplus_dU_c_110 = ofLadj CU_111_1_pre CU_111_1_pim := by
  rw [CU_0_c_001_def, Fplus_dU_c_110_def, ofLadj_mul, CU_111_1_pre_eq, CU_111_1_pim_eq]

def CU_111_2_pre : Polynomial ℚ := C ((-40695788941004 / 235794999 : ℚ)) + C ((-553069849643120 / 235794999 : ℚ)) * X + C ((-375028084570856 / 78598333 : ℚ)) * X ^ 2 + C ((-1847988373484204 / 235794999 : ℚ)) * X ^ 3 + C ((-2751821685793456 / 235794999 : ℚ)) * X ^ 4 + C ((-3270672368075540 / 235794999 : ℚ)) * X ^ 5 + C ((-3687222469470260 / 235794999 : ℚ)) * X ^ 6 + C ((-1305609732222344 / 78598333 : ℚ)) * X ^ 7 + C ((-113089236652020 / 7145303 : ℚ)) * X ^ 8 + C ((-1220453080213968 / 78598333 : ℚ)) * X ^ 9 + C ((-3607544516275672 / 235794999 : ℚ)) * X ^ 10 + C ((-1182277310940340 / 78598333 : ℚ)) * X ^ 11 + C ((-3054474666632552 / 235794999 : ℚ)) * X ^ 12 + C ((-845424995643112 / 78598333 : ℚ)) * X ^ 13 + C ((-1883956436032456 / 235794999 : ℚ)) * X ^ 14 + C ((-1044957520588340 / 235794999 : ℚ)) * X ^ 15 + C ((-188186062492436 / 78598333 : ℚ)) * X ^ 16 + C ((-49336028694196 / 78598333 : ℚ)) * X ^ 17 + C ((3637878493492 / 7145303 : ℚ)) * X ^ 18
def CU_111_2_pim : Polynomial ℚ := C ((372496773731612 / 235794999 : ℚ)) + C ((744993547463224 / 235794999 : ℚ)) * X + C ((883264516171736 / 235794999 : ℚ)) * X ^ 2 + C ((1040435434703380 / 235794999 : ℚ)) * X ^ 3 + C ((261232208597632 / 78598333 : ℚ)) * X ^ 4 + C ((273043710569120 / 235794999 : ℚ)) * X ^ 5 + C ((-12320175750584 / 21435909 : ℚ)) * X ^ 6 + C ((-735173034191732 / 235794999 : ℚ)) * X ^ 7 + C ((-1079864855330752 / 235794999 : ℚ)) * X ^ 8 + C ((-1069699154107472 / 235794999 : ℚ)) * X ^ 9 + C ((-340993038406804 / 78598333 : ℚ)) * X ^ 10 + C ((-1327157032317676 / 235794999 : ℚ)) * X ^ 11 + C ((-148303177219540 / 21435909 : ℚ)) * X ^ 12 + C ((-1722885879236392 / 235794999 : ℚ)) * X ^ 13 + C ((-1869891096544756 / 235794999 : ℚ)) * X ^ 14 + C ((-547604526864184 / 78598333 : ℚ)) * X ^ 15 + C ((-397371819235236 / 78598333 : ℚ)) * X ^ 16 + C ((-854726836779116 / 235794999 : ℚ)) * X ^ 17 + C ((-315030528180740 / 235794999 : ℚ)) * X ^ 18
theorem CU_111_2_pre_eq :
    CU_1_re_010 * Fplus_dV_re_101 - CU_1_im_010 * Fplus_dV_im_101 = CU_111_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_111_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_2_pim_eq :
    CU_1_re_010 * Fplus_dV_im_101 + CU_1_im_010 * Fplus_dV_re_101 = CU_111_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_111_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_2_mul :
    CU_1_c_010 * Fplus_dV_c_101 = ofLadj CU_111_2_pre CU_111_2_pim := by
  rw [CU_1_c_010_def, Fplus_dV_c_101_def, ofLadj_mul, CU_111_2_pre_eq, CU_111_2_pim_eq]

def CU_111_3_pre : Polynomial ℚ := C ((142360682540 / 78598333 : ℚ)) + C ((362196663527040 / 78598333 : ℚ)) * X + C ((2057182737717460 / 235794999 : ℚ)) * X ^ 2 + C ((3542754300636868 / 235794999 : ℚ)) * X ^ 3 + C ((1927184346732508 / 78598333 : ℚ)) * X ^ 4 + C ((7460355599381752 / 235794999 : ℚ)) * X ^ 5 + C ((3031543549070252 / 78598333 : ℚ)) * X ^ 6 + C ((3470859854306248 / 78598333 : ℚ)) * X ^ 7 + C ((10586758885102024 / 235794999 : ℚ)) * X ^ 8 + C ((10956226590008408 / 235794999 : ℚ)) * X ^ 9 + C ((3746122770449516 / 78598333 : ℚ)) * X ^ 10 + C ((3781018687054956 / 78598333 : ℚ)) * X ^ 11 + C ((3383926106922476 / 78598333 : ℚ)) * X ^ 12 + C ((8899043852290948 / 235794999 : ℚ)) * X ^ 13 + C ((213454684377732 / 7145303 : ℚ)) * X ^ 14 + C ((4465626123650836 / 235794999 : ℚ)) * X ^ 15 + C ((2585035660687096 / 235794999 : ℚ)) * X ^ 16 + C ((950760612858092 / 235794999 : ℚ)) * X ^ 17 + C ((-165400399070384 / 235794999 : ℚ)) * X ^ 18
def CU_111_3_pim : Polynomial ℚ := C ((-334457400821284 / 78598333 : ℚ)) + C ((-668914801642568 / 78598333 : ℚ)) * X + C ((-2711199153436612 / 235794999 : ℚ)) * X ^ 2 + C ((-3807921439385432 / 235794999 : ℚ)) * X ^ 3 + C ((-1328181295294952 / 78598333 : ℚ)) * X ^ 4 + C ((-3543037203567956 / 235794999 : ℚ)) * X ^ 5 + C ((-3107185637001640 / 235794999 : ℚ)) * X ^ 6 + C ((-1850541518598536 / 235794999 : ℚ)) * X ^ 7 + C ((-316719104686800 / 78598333 : ℚ)) * X ^ 8 + C ((-299018331972572 / 78598333 : ℚ)) * X ^ 9 + C ((-217525003547332 / 78598333 : ℚ)) * X ^ 10 + C ((21483252270572 / 7145303 : ℚ)) * X ^ 11 + C ((690156553499916 / 78598333 : ℚ)) * X ^ 12 + C ((3019404394284376 / 235794999 : ℚ)) * X ^ 13 + C ((4169228998375880 / 235794999 : ℚ)) * X ^ 14 + C ((1396935079388264 / 78598333 : ℚ)) * X ^ 15 + C ((1145075745902080 / 78598333 : ℚ)) * X ^ 16 + C ((875381949264468 / 78598333 : ℚ)) * X ^ 17 + C ((1055430411248648 / 235794999 : ℚ)) * X ^ 18
theorem CU_111_3_pre_eq :
    CU_1_re_001 * Fplus_dV_re_110 - CU_1_im_001 * Fplus_dV_im_110 = CU_111_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_111_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_3_pim_eq :
    CU_1_re_001 * Fplus_dV_im_110 + CU_1_im_001 * Fplus_dV_re_110 = CU_111_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_111_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_3_mul :
    CU_1_c_001 * Fplus_dV_c_110 = ofLadj CU_111_3_pre CU_111_3_pim := by
  rw [CU_1_c_001_def, Fplus_dV_c_110_def, ofLadj_mul, CU_111_3_pre_eq, CU_111_3_pim_eq]

def CU_111_4_pre : Polynomial ℚ := C ((-24037211052820 / 235794999 : ℚ)) + C ((-380672528548144 / 235794999 : ℚ)) * X + C ((-760991664209060 / 235794999 : ℚ)) * X ^ 2 + C ((-1237800633114560 / 235794999 : ℚ)) * X ^ 3 + C ((-1878854268366512 / 235794999 : ℚ)) * X ^ 4 + C ((-2270907510722368 / 235794999 : ℚ)) * X ^ 5 + C ((-79707232517336 / 7145303 : ℚ)) * X ^ 6 + C ((-2868577041989468 / 235794999 : ℚ)) * X ^ 7 + C ((-2819547599740028 / 235794999 : ℚ)) * X ^ 8 + C ((-952491807731300 / 78598333 : ℚ)) * X ^ 9 + C ((-2886374578980632 / 235794999 : ℚ)) * X ^ 10 + C ((-2873029724185208 / 235794999 : ℚ)) * X ^ 11 + C ((-2505702050432488 / 235794999 : ℚ)) * X ^ 12 + C ((-2096483758984840 / 235794999 : ℚ)) * X ^ 13 + C ((-527248988875156 / 78598333 : ℚ)) * X ^ 14 + C ((-905849954047484 / 235794999 : ℚ)) * X ^ 15 + C ((-493197178574828 / 235794999 : ℚ)) * X ^ 16 + C ((-44588672075036 / 78598333 : ℚ)) * X ^ 17 + C ((83872819575472 / 235794999 : ℚ)) * X ^ 18
def CU_111_4_pim : Polynomial ℚ := C ((272380078932748 / 235794999 : ℚ)) + C ((544760157865496 / 235794999 : ℚ)) * X + C ((665970439916420 / 235794999 : ℚ)) * X ^ 2 + C ((276863361940052 / 78598333 : ℚ)) * X ^ 3 + C ((719841182383436 / 235794999 : ℚ)) * X ^ 4 + C ((144355868531972 / 78598333 : ℚ)) * X ^ 5 + C ((209831872143796 / 235794999 : ℚ)) * X ^ 6 + C ((-192812217219148 / 235794999 : ℚ)) * X ^ 7 + C ((-424571249356612 / 235794999 : ℚ)) * X ^ 8 + C ((-39093916188616 / 21435909 : ℚ)) * X ^ 9 + C ((-455169646410224 / 235794999 : ℚ)) * X ^ 10 + C ((-764207157780664 / 235794999 : ℚ)) * X ^ 11 + C ((-357748223050368 / 78598333 : ℚ)) * X ^ 12 + C ((-406530506512492 / 78598333 : ℚ)) * X ^ 13 + C ((-1389672994159376 / 235794999 : ℚ)) * X ^ 14 + C ((-420991211485824 / 78598333 : ℚ)) * X ^ 15 + C ((-314657630460872 / 78598333 : ℚ)) * X ^ 16 + C ((-682580744052928 / 235794999 : ℚ)) * X ^ 17 + C ((-247709488402648 / 235794999 : ℚ)) * X ^ 18
theorem CU_111_4_pre_eq :
    CU_2_re_010 * Fplus_dW_re_101 - CU_2_im_010 * Fplus_dW_im_101 = CU_111_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_111_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_4_pim_eq :
    CU_2_re_010 * Fplus_dW_im_101 + CU_2_im_010 * Fplus_dW_re_101 = CU_111_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_111_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_4_mul :
    CU_2_c_010 * Fplus_dW_c_101 = ofLadj CU_111_4_pre CU_111_4_pim := by
  rw [CU_2_c_010_def, Fplus_dW_c_101_def, ofLadj_mul, CU_111_4_pre_eq, CU_111_4_pim_eq]

def CU_111_5_pre : Polynomial ℚ := C ((14179659001880 / 78598333 : ℚ)) + C ((191725470513120 / 78598333 : ℚ)) * X + C ((390084828701408 / 78598333 : ℚ)) * X ^ 2 + C ((1924148225314672 / 235794999 : ℚ)) * X ^ 3 + C ((2864222102888600 / 235794999 : ℚ)) * X ^ 4 + C ((1134481749097748 / 78598333 : ℚ)) * X ^ 5 + C ((3838457956262420 / 235794999 : ℚ)) * X ^ 6 + C ((4076819656584188 / 235794999 : ℚ)) * X ^ 7 + C ((3883735264605920 / 235794999 : ℚ)) * X ^ 8 + C ((115465026157968 / 7145303 : ℚ)) * X ^ 9 + C ((3754255406219504 / 235794999 : ℚ)) * X ^ 10 + C ((3690772296601072 / 235794999 : ℚ)) * X ^ 11 + C ((3179078994680144 / 235794999 : ℚ)) * X ^ 12 + C ((880030459036240 / 78598333 : ℚ)) * X ^ 13 + C ((1959587039291248 / 235794999 : ℚ)) * X ^ 14 + C ((1086979386968828 / 235794999 : ℚ)) * X ^ 15 + C ((587916799966328 / 235794999 : ℚ)) * X ^ 16 + C ((4633457302944 / 7145303 : ℚ)) * X ^ 17 + C ((-125618166726760 / 235794999 : ℚ)) * X ^ 18
def CU_111_5_pim : Polynomial ℚ := C ((-35208680246056 / 21435909 : ℚ)) + C ((-70417360492112 / 21435909 : ℚ)) * X + C ((-919437123938192 / 235794999 : ℚ)) * X ^ 2 + C ((-1082836846086608 / 235794999 : ℚ)) * X ^ 3 + C ((-271327089809480 / 78598333 : ℚ)) * X ^ 4 + C ((-94521934671068 / 78598333 : ℚ)) * X ^ 5 + C ((47323435115316 / 78598333 : ℚ)) * X ^ 6 + C ((69770310922612 / 21435909 : ℚ)) * X ^ 7 + C ((1125949311691832 / 235794999 : ℚ)) * X ^ 8 + C ((371803129694776 / 78598333 : ℚ)) * X ^ 9 + C ((355623952589588 / 78598333 : ℚ)) * X ^ 10 + C ((1382951022188288 / 235794999 : ℚ)) * X ^ 11 + C ((1699030186607812 / 235794999 : ℚ)) * X ^ 12 + C ((163212619437928 / 21435909 : ℚ)) * X ^ 13 + C ((649399537786040 / 78598333 : ℚ)) * X ^ 14 + C ((155465161324300 / 21435909 : ℚ)) * X ^ 15 + C ((37639384736904 / 7145303 : ℚ)) * X ^ 16 + C ((296935627104256 / 78598333 : ℚ)) * X ^ 17 + C ((327702153675752 / 235794999 : ℚ)) * X ^ 18
theorem CU_111_5_pre_eq :
    CU_2_re_001 * Fplus_dW_re_110 - CU_2_im_001 * Fplus_dW_im_110 = CU_111_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_111_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_5_pim_eq :
    CU_2_re_001 * Fplus_dW_im_110 + CU_2_im_001 * Fplus_dW_re_110 = CU_111_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_111_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_5_mul :
    CU_2_c_001 * Fplus_dW_c_110 = ofLadj CU_111_5_pre CU_111_5_pim := by
  rw [CU_2_c_001_def, Fplus_dW_c_110_def, ofLadj_mul, CU_111_5_pre_eq, CU_111_5_pim_eq]

def CU_111_6_pre : Polynomial ℚ := C ((-63062818076 / 21435909 : ℚ)) + C ((57212635956 / 7145303 : ℚ)) * X ^ 2 + C ((395683010884 / 21435909 : ℚ)) * X ^ 3 + C ((200733406376 / 7145303 : ℚ)) * X ^ 4 + C ((724320393596 / 21435909 : ℚ)) * X ^ 5 + C ((724320393596 / 21435909 : ℚ)) * X ^ 6 + C ((200733406376 / 7145303 : ℚ)) * X ^ 7 + C ((395683010884 / 21435909 : ℚ)) * X ^ 8 + C ((57212635956 / 7145303 : ℚ)) * X ^ 9
def CU_111_6_pim : Polynomial ℚ := C ((-2389077998620 / 235794999 : ℚ)) + C ((-4778155997240 / 235794999 : ℚ)) * X + C ((-6415244167336 / 235794999 : ℚ)) * X ^ 2 + C ((-6766576349036 / 235794999 : ℚ)) * X ^ 3 + C ((-1911337894588 / 78598333 : ℚ)) * X ^ 4 + C ((-1210247427124 / 78598333 : ℚ)) * X ^ 5 + C ((-1147413715868 / 235794999 : ℚ)) * X ^ 6 + C ((955857686524 / 235794999 : ℚ)) * X ^ 7 + C ((662806783932 / 78598333 : ℚ)) * X ^ 8 + C ((1637088170096 / 235794999 : ℚ)) * X ^ 9
theorem CU_111_6_neg_re : -CU_3_re_111 = CU_111_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_111_def, CU_111_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_6_neg_im : -CU_3_im_111 = CU_111_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_111_def, CU_111_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_111_6_mul : -CU_3_c_111 = ofLadj CU_111_6_pre CU_111_6_pim := by
  rw [CU_3_c_111_def, ofLadj_neg, CU_111_6_neg_re, CU_111_6_neg_im]

theorem CU_111_7_mul : CU_3_c_011 = ofLadj CU_3_re_011 CU_3_im_011 := CU_3_c_011_def

@[expose] public def CU_coeff_111 : Ki := CU_0_c_010 * Fplus_dU_c_101 + CU_0_c_001 * Fplus_dU_c_110 + CU_1_c_010 * Fplus_dV_c_101 + CU_1_c_001 * Fplus_dV_c_110 + CU_2_c_010 * Fplus_dW_c_101 + CU_2_c_001 * Fplus_dW_c_110 + (-CU_3_c_111) + CU_3_c_011

theorem CU_coeff_111_sum :
    CU_coeff_111 = ofLadj (CU_111_0_pre + CU_111_1_pre + CU_111_2_pre + CU_111_3_pre + CU_111_4_pre + CU_111_5_pre + CU_111_6_pre + CU_3_re_011) (CU_111_0_pim + CU_111_1_pim + CU_111_2_pim + CU_111_3_pim + CU_111_4_pim + CU_111_5_pim + CU_111_6_pim + CU_3_im_011) := by
  simp only [CU_coeff_111, CU_111_0_mul, CU_111_1_mul, CU_111_2_mul, CU_111_3_mul, CU_111_4_mul, CU_111_5_mul, CU_111_6_mul, CU_111_7_mul]
  simp [ofLadj_add, add_assoc]

def CU_111_qre : Polynomial ℚ := C ((47024925902396 / 235794999 : ℚ)) + C ((1840681292287108 / 235794999 : ℚ)) * X + C ((1712969743423436 / 235794999 : ℚ)) * X ^ 2 + C ((802118111569792 / 78598333 : ℚ)) * X ^ 3 + C ((1241244572795748 / 78598333 : ℚ)) * X ^ 4 + C ((2613025748625896 / 235794999 : ℚ)) * X ^ 5 + C ((2457986652460136 / 235794999 : ℚ)) * X ^ 6 + C ((1602456128456564 / 235794999 : ℚ)) * X ^ 7 + C ((-400023094363712 / 235794999 : ℚ)) * X ^ 8
def CU_111_qim : Polynomial ℚ := C ((-1584241489659460 / 235794999 : ℚ)) + C ((-1584241489659460 / 235794999 : ℚ)) * X + C ((-306858297607016 / 78598333 : ℚ)) * X ^ 2 + C ((-505712241220740 / 78598333 : ℚ)) * X ^ 3 + C ((36097449240604 / 235794999 : ℚ)) * X ^ 4 + C ((113491746297808 / 21435909 : ℚ)) * X ^ 5 + C ((1247693017574572 / 235794999 : ℚ)) * X ^ 6 + C ((235015039441612 / 21435909 : ℚ)) * X ^ 7 + C ((1613603395350244 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_111_poly_re :
    CU_111_0_pre + CU_111_1_pre + CU_111_2_pre + CU_111_3_pre + CU_111_4_pre + CU_111_5_pre + CU_111_6_pre + CU_3_re_011 = (0 : Polynomial ℚ) + Phi11 * CU_111_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_111_0_pre, CU_111_1_pre, CU_111_2_pre, CU_111_3_pre, CU_111_4_pre, CU_111_5_pre, CU_111_6_pre, CU_3_re_011_def, CU_111_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_111_poly_im :
    CU_111_0_pim + CU_111_1_pim + CU_111_2_pim + CU_111_3_pim + CU_111_4_pim + CU_111_5_pim + CU_111_6_pim + CU_3_im_011 = (0 : Polynomial ℚ) + Phi11 * CU_111_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_111_0_pim, CU_111_1_pim, CU_111_2_pim, CU_111_3_pim, CU_111_4_pim, CU_111_5_pim, CU_111_6_pim, CU_3_im_011_def, CU_111_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_111_eq :
    CU_coeff_111 = (0 : Ki) := by
  rw [CU_coeff_111_sum, CU_coeff_111_poly_re,
    CU_coeff_111_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
