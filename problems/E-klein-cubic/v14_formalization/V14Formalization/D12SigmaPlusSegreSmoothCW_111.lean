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

def CW_111_0_pre : Polynomial ℚ := C ((-1494896076370 / 2879985977 : ℚ)) + C ((-23169502618760 / 2879985977 : ℚ)) * X + C ((-46697181315662 / 2879985977 : ℚ)) * X ^ 2 + C ((-77126472780404 / 2879985977 : ℚ)) * X ^ 3 + C ((-2853798906646 / 71404611 : ℚ)) * X ^ 4 + C ((-136386595008515 / 2879985977 : ℚ)) * X ^ 5 + C ((-154255354896551 / 2879985977 : ℚ)) * X ^ 6 + C ((-490436055323564 / 8639957931 : ℚ)) * X ^ 7 + C ((-467176763566567 / 8639957931 : ℚ)) * X ^ 8 + C ((-13887348097759 / 261816907 : ℚ)) * X ^ 9 + C ((-451574962087067 / 8639957931 : ℚ)) * X ^ 10 + C ((-148176843475900 / 2879985977 : ℚ)) * X ^ 11 + C ((-382066454230787 / 8639957931 : ℚ)) * X ^ 12 + C ((-106063647759687 / 2879985977 : ℚ)) * X ^ 13 + C ((-235797345225355 / 8639957931 : ℚ)) * X ^ 14 + C ((-43333908659566 / 2879985977 : ℚ)) * X ^ 15 + C ((-71021932475774 / 8639957931 : ℚ)) * X ^ 16 + C ((-17415652811666 / 8639957931 : ℚ)) * X ^ 17 + C ((15124661640700 / 8639957931 : ℚ)) * X ^ 18
def CW_111_0_pim : Polynomial ℚ := C ((47076954186668 / 8639957931 : ℚ)) + C ((94153908373336 / 8639957931 : ℚ)) * X + C ((111045804310412 / 8639957931 : ℚ)) * X ^ 2 + C ((4014934909644 / 261816907 : ℚ)) * X ^ 3 + C ((32946294284908 / 2879985977 : ℚ)) * X ^ 4 + C ((1086691799079 / 261816907 : ℚ)) * X ^ 5 + C ((-15525469450187 / 8639957931 : ℚ)) * X ^ 6 + C ((-30467080742654 / 2879985977 : ℚ)) * X ^ 7 + C ((-133737606769331 / 8639957931 : ℚ)) * X ^ 8 + C ((-12038342139037 / 785450721 : ℚ)) * X ^ 9 + C ((-42195011577027 / 2879985977 : ℚ)) * X ^ 10 + C ((-55023076715498 / 2879985977 : ℚ)) * X ^ 11 + C ((-67851141853969 / 2879985977 : ℚ)) * X ^ 12 + C ((-214608592700657 / 8639957931 : ℚ)) * X ^ 13 + C ((-78246599056191 / 2879985977 : ℚ)) * X ^ 14 + C ((-68273277985138 / 2879985977 : ℚ)) * X ^ 15 + C ((-49779005390684 / 2879985977 : ℚ)) * X ^ 16 + C ((-35660965222340 / 2879985977 : ℚ)) * X ^ 17 + C ((-38602358591000 / 8639957931 : ℚ)) * X ^ 18
theorem CW_111_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_011 - CW_0_im_100 * Fplus_dU_im_011 = CW_111_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100, CW_0_im_100, Fplus_dU_re_011, Fplus_dU_im_011, CW_111_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_011 + CW_0_im_100 * Fplus_dU_re_011 = CW_111_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100, CW_0_im_100, Fplus_dU_re_011, Fplus_dU_im_011, CW_111_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_0_mul :
    CW_0_c_100 * Fplus_dU_c_011 = ofLadj CW_111_0_pre CW_111_0_pim := by
  rw [CW_0_c_100, Fplus_dU_c_011, ofLadj_mul, CW_111_0_pre_eq, CW_111_0_pim_eq]

def CW_111_1_pre : Polynomial ℚ := C ((-392796323120 / 785450721 : ℚ)) + C ((-35711193776128 / 8639957931 : ℚ)) * X + C ((-65881373620376 / 8639957931 : ℚ)) * X ^ 2 + C ((-34737340625072 / 2879985977 : ℚ)) * X ^ 3 + C ((-149382834476456 / 8639957931 : ℚ)) * X ^ 4 + C ((-168763333112258 / 8639957931 : ℚ)) * X ^ 5 + C ((-62443102936070 / 2879985977 : ℚ)) * X ^ 6 + C ((-193484379617005 / 8639957931 : ℚ)) * X ^ 7 + C ((-5441080667323 / 261816907 : ℚ)) * X ^ 8 + C ((-58965502648526 / 2879985977 : ℚ)) * X ^ 9 + C ((-58236399207201 / 2879985977 : ℚ)) * X ^ 10 + C ((-169729435778750 / 8639957931 : ℚ)) * X ^ 11 + C ((-138998003845475 / 8639957931 : ℚ)) * X ^ 12 + C ((-111015134325202 / 8639957931 : ℚ)) * X ^ 13 + C ((-25114546715481 / 2879985977 : ℚ)) * X ^ 14 + C ((-270481258313 / 71404611 : ℚ)) * X ^ 15 + C ((-14775216654278 / 8639957931 : ℚ)) * X ^ 16 + C ((344614458334 / 785450721 : ℚ)) * X ^ 17 + C ((3791104294892 / 2879985977 : ℚ)) * X ^ 18
def CW_111_1_pim : Polynomial ℚ := C ((5487685641952 / 2879985977 : ℚ)) + C ((10975371283904 / 2879985977 : ℚ)) * X + C ((30523041309856 / 8639957931 : ℚ)) * X ^ 2 + C ((32710293602980 / 8639957931 : ℚ)) * X ^ 3 + C ((8865196123504 / 8639957931 : ℚ)) * X ^ 4 + C ((-2097337796024 / 785450721 : ℚ)) * X ^ 5 + C ((-48297924309892 / 8639957931 : ℚ)) * X ^ 6 + C ((-82311268811465 / 8639957931 : ℚ)) * X ^ 7 + C ((-99093598130095 / 8639957931 : ℚ)) * X ^ 8 + C ((-32935319410468 / 2879985977 : ℚ)) * X ^ 9 + C ((-97006257867323 / 8639957931 : ℚ)) * X ^ 10 + C ((-110797691558432 / 8639957931 : ℚ)) * X ^ 11 + C ((-124589125249541 / 8639957931 : ℚ)) * X ^ 12 + C ((-120386352343604 / 8639957931 : ℚ)) * X ^ 13 + C ((-122285964738037 / 8639957931 : ℚ)) * X ^ 14 + C ((-33151530187825 / 2879985977 : ℚ)) * X ^ 15 + C ((-23307860179132 / 2879985977 : ℚ)) * X ^ 16 + C ((-47377048661600 / 8639957931 : ℚ)) * X ^ 17 + C ((-5256202004572 / 2879985977 : ℚ)) * X ^ 18
theorem CW_111_1_pre_eq :
    CW_0_re_010 * Fplus_dU_re_101 - CW_0_im_010 * Fplus_dU_im_101 = CW_111_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_101, Fplus_dU_im_101, CW_111_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_1_pim_eq :
    CW_0_re_010 * Fplus_dU_im_101 + CW_0_im_010 * Fplus_dU_re_101 = CW_111_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_101, Fplus_dU_im_101, CW_111_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_1_mul :
    CW_0_c_010 * Fplus_dU_c_101 = ofLadj CW_111_1_pre CW_111_1_pim := by
  rw [CW_0_c_010, Fplus_dU_c_101, ofLadj_mul, CW_111_1_pre_eq, CW_111_1_pim_eq]

def CW_111_2_pre : Polynomial ℚ := C ((7151957062460 / 8639957931 : ℚ)) + C ((120703746449888 / 8639957931 : ℚ)) * X + C ((79259189764894 / 2879985977 : ℚ)) * X ^ 2 + C ((129968451909470 / 2879985977 : ℚ)) * X ^ 3 + C ((194224883170211 / 2879985977 : ℚ)) * X ^ 4 + C ((691812571083311 / 8639957931 : ℚ)) * X ^ 5 + C ((261562445451041 / 2879985977 : ℚ)) * X ^ 6 + C ((838396793034674 / 8639957931 : ℚ)) * X ^ 7 + C ((799404988119182 / 8639957931 : ℚ)) * X ^ 8 + C ((263388345303893 / 2879985977 : ℚ)) * X ^ 9 + C ((783522162707275 / 8639957931 : ℚ)) * X ^ 10 + C ((773514881844718 / 8639957931 : ℚ)) * X ^ 11 + C ((662818416257387 / 8639957931 : ℚ)) * X ^ 12 + C ((16739014139909 / 261816907 : ℚ)) * X ^ 13 + C ((37227239308252 / 785450721 : ℚ)) * X ^ 14 + C ((6814508933340 / 261816907 : ℚ)) * X ^ 15 + C ((120770717190347 / 8639957931 : ℚ)) * X ^ 16 + C ((27895951920535 / 8639957931 : ℚ)) * X ^ 17 + C ((-30843348723821 / 8639957931 : ℚ)) * X ^ 18
def CW_111_2_pim : Polynomial ℚ := C ((-7524079968644 / 785450721 : ℚ)) + C ((-15048159937288 / 785450721 : ℚ)) * X + C ((-64014730211112 / 2879985977 : ℚ)) * X ^ 2 + C ((-77754770944848 / 2879985977 : ℚ)) * X ^ 3 + C ((-59243223385759 / 2879985977 : ℚ)) * X ^ 4 + C ((-23583475435849 / 2879985977 : ℚ)) * X ^ 5 + C ((16752792245845 / 8639957931 : ℚ)) * X ^ 6 + C ((149162006894932 / 8639957931 : ℚ)) * X ^ 7 + C ((226000378431332 / 8639957931 : ℚ)) * X ^ 8 + C ((224489112766837 / 8639957931 : ℚ)) * X ^ 9 + C ((72861892631747 / 2879985977 : ℚ)) * X ^ 10 + C ((292589148274700 / 8639957931 : ℚ)) * X ^ 11 + C ((366592618654159 / 8639957931 : ℚ)) * X ^ 12 + C ((387203615105731 / 8639957931 : ℚ)) * X ^ 13 + C ((142304157214148 / 2879985977 : ℚ)) * X ^ 14 + C ((375456615347824 / 8639957931 : ℚ)) * X ^ 15 + C ((91964804922209 / 2879985977 : ℚ)) * X ^ 16 + C ((197751756534307 / 8639957931 : ℚ)) * X ^ 17 + C ((24253195051251 / 2879985977 : ℚ)) * X ^ 18
theorem CW_111_2_pre_eq :
    CW_1_re_100 * Fplus_dV_re_011 - CW_1_im_100 * Fplus_dV_im_011 = CW_111_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100, CW_1_im_100, Fplus_dV_re_011, Fplus_dV_im_011, CW_111_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_2_pim_eq :
    CW_1_re_100 * Fplus_dV_im_011 + CW_1_im_100 * Fplus_dV_re_011 = CW_111_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100, CW_1_im_100, Fplus_dV_re_011, Fplus_dV_im_011, CW_111_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_2_mul :
    CW_1_c_100 * Fplus_dV_c_011 = ofLadj CW_111_2_pre CW_111_2_pim := by
  rw [CW_1_c_100, Fplus_dV_c_011, ofLadj_mul, CW_111_2_pre_eq, CW_111_2_pim_eq]

def CW_111_3_pre : Polynomial ℚ := C ((1025888764706 / 8639957931 : ℚ)) + C ((24825587592200 / 8639957931 : ℚ)) * X + C ((1509809401732 / 261816907 : ℚ)) * X ^ 2 + C ((81279463180912 / 8639957931 : ℚ)) * X ^ 3 + C ((122628060656572 / 8639957931 : ℚ)) * X ^ 4 + C ((48574645066583 / 2879985977 : ℚ)) * X ^ 5 + C ((164023711035425 / 8639957931 : ℚ)) * X ^ 6 + C ((57923484170788 / 2879985977 : ℚ)) * X ^ 7 + C ((55245496083304 / 2879985977 : ℚ)) * X ^ 8 + C ((162509793431393 / 8639957931 : ℚ)) * X ^ 9 + C ((53395500525154 / 2879985977 : ℚ)) * X ^ 10 + C ((158309260177628 / 8639957931 : ℚ)) * X ^ 11 + C ((12305537634842 / 785450721 : ℚ)) * X ^ 12 + C ((112686083174237 / 8639957931 : ℚ)) * X ^ 13 + C ((84457025069000 / 8639957931 : ℚ)) * X ^ 14 + C ((4185351777302 / 785450721 : ℚ)) * X ^ 15 + C ((24620817404776 / 8639957931 : ℚ)) * X ^ 16 + C ((6321041569100 / 8639957931 : ℚ)) * X ^ 17 + C ((-5103522305470 / 8639957931 : ℚ)) * X ^ 18
def CW_111_3_pim : Polynomial ℚ := C ((-5684632536960 / 2879985977 : ℚ)) + C ((-11369265073920 / 2879985977 : ℚ)) * X + C ((-39282147562534 / 8639957931 : ℚ)) * X ^ 2 + C ((-4336940752030 / 785450721 : ℚ)) * X ^ 3 + C ((-36437470772480 / 8639957931 : ℚ)) * X ^ 4 + C ((-13193083255705 / 8639957931 : ℚ)) * X ^ 5 + C ((5101729165459 / 8639957931 : ℚ)) * X ^ 6 + C ((10466292750898 / 2879985977 : ℚ)) * X ^ 7 + C ((4237422645452 / 785450721 : ℚ)) * X ^ 8 + C ((15358202722919 / 2879985977 : ℚ)) * X ^ 9 + C ((43904528690012 / 8639957931 : ℚ)) * X ^ 10 + C ((1757237904850 / 261816907 : ℚ)) * X ^ 11 + C ((72073173030088 / 8639957931 : ℚ)) * X ^ 12 + C ((75077445892117 / 8639957931 : ℚ)) * X ^ 13 + C ((82964605670698 / 8639957931 : ℚ)) * X ^ 14 + C ((24374988242904 / 2879985977 : ℚ)) * X ^ 15 + C ((52560087242314 / 8639957931 : ℚ)) * X ^ 16 + C ((37401173346272 / 8639957931 : ℚ)) * X ^ 17 + C ((13783534289414 / 8639957931 : ℚ)) * X ^ 18
theorem CW_111_3_pre_eq :
    CW_1_re_010 * Fplus_dV_re_101 - CW_1_im_010 * Fplus_dV_im_101 = CW_111_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_101, Fplus_dV_im_101, CW_111_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_3_pim_eq :
    CW_1_re_010 * Fplus_dV_im_101 + CW_1_im_010 * Fplus_dV_re_101 = CW_111_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_101, Fplus_dV_im_101, CW_111_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_3_mul :
    CW_1_c_010 * Fplus_dV_c_101 = ofLadj CW_111_3_pre CW_111_3_pim := by
  rw [CW_1_c_010, Fplus_dV_c_101, ofLadj_mul, CW_111_3_pre_eq, CW_111_3_pim_eq]

def CW_111_4_pre : Polynomial ℚ := C ((342538009853 / 8639957931 : ℚ)) + C ((-181078965172 / 785450721 : ℚ)) * X + C ((-1335730360462 / 2879985977 : ℚ)) * X ^ 2 + C ((-7020352408183 / 8639957931 : ℚ)) * X ^ 3 + C ((-342662789406 / 261816907 : ℚ)) * X ^ 4 + C ((-14457054473272 / 8639957931 : ℚ)) * X ^ 5 + C ((-5787122140718 / 2879985977 : ℚ)) * X ^ 6 + C ((-5963732367610 / 2879985977 : ℚ)) * X ^ 7 + C ((-1469817052216 / 785450721 : ℚ)) * X ^ 8 + C ((-14877139586555 / 8639957931 : ℚ)) * X ^ 9 + C ((-14066742700133 / 8639957931 : ℚ)) * X ^ 10 + C ((-1269797557526 / 785450721 : ℚ)) * X ^ 11 + C ((-4024958027747 / 2879985977 : ℚ)) * X ^ 12 + C ((-10869948505169 / 8639957931 : ℚ)) * X ^ 13 + C ((-9147635166193 / 8639957931 : ℚ)) * X ^ 14 + C ((-1987394745692 / 2879985977 : ℚ)) * X ^ 15 + C ((-1187307880320 / 2879985977 : ℚ)) * X ^ 16 + C ((-59782881098 / 785450721 : ℚ)) * X ^ 17 + C ((207046938452 / 2879985977 : ℚ)) * X ^ 18
def CW_111_4_pim : Polynomial ℚ := C ((733998302637 / 2879985977 : ℚ)) + C ((1467996605274 / 2879985977 : ℚ)) * X + C ((5216722363322 / 8639957931 : ℚ)) * X ^ 2 + C ((2339153686109 / 2879985977 : ℚ)) * X ^ 3 + C ((198380132156 / 261816907 : ℚ)) * X ^ 4 + C ((4899539143786 / 8639957931 : ℚ)) * X ^ 5 + C ((744302046666 / 2879985977 : ℚ)) * X ^ 6 + C ((-1449561164866 / 8639957931 : ℚ)) * X ^ 7 + C ((-3447387318184 / 8639957931 : ℚ)) * X ^ 8 + C ((-95269763075 / 261816907 : ℚ)) * X ^ 9 + C ((-2330660536031 / 8639957931 : ℚ)) * X ^ 10 + C ((-1128556773108 / 2879985977 : ℚ)) * X ^ 11 + C ((-403698191147 / 785450721 : ℚ)) * X ^ 12 + C ((-4440171004673 / 8639957931 : ℚ)) * X ^ 13 + C ((-5937424562969 / 8639957931 : ℚ)) * X ^ 14 + C ((-6087721955396 / 8639957931 : ℚ)) * X ^ 15 + C ((-5409000256744 / 8639957931 : ℚ)) * X ^ 16 + C ((-123963510602 / 261816907 : ℚ)) * X ^ 17 + C ((-458870687904 / 2879985977 : ℚ)) * X ^ 18
theorem CW_111_4_pre_eq :
    CW_2_re_100 * Fplus_dW_re_011 - CW_2_im_100 * Fplus_dW_im_011 = CW_111_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100, CW_2_im_100, Fplus_dW_re_011, Fplus_dW_im_011, CW_111_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_4_pim_eq :
    CW_2_re_100 * Fplus_dW_im_011 + CW_2_im_100 * Fplus_dW_re_011 = CW_111_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100, CW_2_im_100, Fplus_dW_re_011, Fplus_dW_im_011, CW_111_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_4_mul :
    CW_2_c_100 * Fplus_dW_c_011 = ofLadj CW_111_4_pre CW_111_4_pim := by
  rw [CW_2_c_100, Fplus_dW_c_011, ofLadj_mul, CW_111_4_pre_eq, CW_111_4_pim_eq]

def CW_111_5_pre : Polynomial ℚ := C ((-4272290820448 / 8639957931 : ℚ)) + C ((-3011157845920 / 8639957931 : ℚ)) * X + C ((-3811112617978 / 2879985977 : ℚ)) * X ^ 2 + C ((-11423743193218 / 8639957931 : ℚ)) * X ^ 3 + C ((-4962431843682 / 2879985977 : ℚ)) * X ^ 4 + C ((-25871307014089 / 8639957931 : ℚ)) * X ^ 5 + C ((-19849643839588 / 8639957931 : ℚ)) * X ^ 6 + C ((-26951206557025 / 8639957931 : ℚ)) * X ^ 7 + C ((-9438949665317 / 2879985977 : ℚ)) * X ^ 8 + C ((-77487351481 / 23801537 : ℚ)) * X ^ 9 + C ((-9581481854723 / 2879985977 : ℚ)) * X ^ 10 + C ((-24098984106550 / 8639957931 : ℚ)) * X ^ 11 + C ((-25733287718249 / 8639957931 : ℚ)) * X ^ 12 + C ((-5564856911223 / 2879985977 : ℚ)) * X ^ 13 + C ((-16893105802733 / 8639957931 : ℚ)) * X ^ 14 + C ((-12986543121517 / 8639957931 : ℚ)) * X ^ 15 + C ((-16119178922 / 71404611 : ℚ)) * X ^ 16 + C ((-7972083824063 / 8639957931 : ℚ)) * X ^ 17 + C ((-307544031846 / 2879985977 : ℚ)) * X ^ 18
def CW_111_5_pim : Polynomial ℚ := C ((17183313836 / 261816907 : ℚ)) + C ((34366627672 / 261816907 : ℚ)) * X + C ((4357205171992 / 8639957931 : ℚ)) * X ^ 2 + C ((-871324614120 / 2879985977 : ℚ)) * X ^ 3 + C ((5914721532506 / 8639957931 : ℚ)) * X ^ 4 + C ((-2551277823155 / 8639957931 : ℚ)) * X ^ 5 + C ((-5413306653016 / 8639957931 : ℚ)) * X ^ 6 + C ((-3060841276415 / 8639957931 : ℚ)) * X ^ 7 + C ((-9113495621911 / 8639957931 : ℚ)) * X ^ 8 + C ((-8779364851825 / 8639957931 : ℚ)) * X ^ 9 + C ((-2989670821801 / 2879985977 : ℚ)) * X ^ 10 + C ((-3262672190048 / 2879985977 : ℚ)) * X ^ 11 + C ((-3535673558295 / 2879985977 : ℚ)) * X ^ 12 + C ((-4673258249093 / 2879985977 : ℚ)) * X ^ 13 + C ((-6714464962841 / 8639957931 : ℚ)) * X ^ 14 + C ((-5241533747179 / 2879985977 : ℚ)) * X ^ 15 + C ((-6632209104776 / 8639957931 : ℚ)) * X ^ 16 + C ((-3845140846165 / 8639957931 : ℚ)) * X ^ 17 + C ((-1857071147222 / 2879985977 : ℚ)) * X ^ 18
theorem CW_111_5_pre_eq :
    CW_2_re_010 * Fplus_dW_re_101 - CW_2_im_010 * Fplus_dW_im_101 = CW_111_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_101, Fplus_dW_im_101, CW_111_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_5_pim_eq :
    CW_2_re_010 * Fplus_dW_im_101 + CW_2_im_010 * Fplus_dW_re_101 = CW_111_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_101, Fplus_dW_im_101, CW_111_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_5_mul :
    CW_2_c_010 * Fplus_dW_c_101 = ofLadj CW_111_5_pre CW_111_5_pim := by
  rw [CW_2_c_010, Fplus_dW_c_101, ofLadj_mul, CW_111_5_pre_eq, CW_111_5_pim_eq]

def CW_111_6_pre : Polynomial ℚ := C ((1853916051 / 261816907 : ℚ)) + C ((-17717566842 / 261816907 : ℚ)) * X ^ 2 + C ((-112543704881 / 785450721 : ℚ)) * X ^ 3 + C ((-175793622497 / 785450721 : ℚ)) * X ^ 4 + C ((-205295299492 / 785450721 : ℚ)) * X ^ 5 + C ((-205295299492 / 785450721 : ℚ)) * X ^ 6 + C ((-175793622497 / 785450721 : ℚ)) * X ^ 7 + C ((-112543704881 / 785450721 : ℚ)) * X ^ 8 + C ((-17717566842 / 261816907 : ℚ)) * X ^ 9
def CW_111_6_pim : Polynomial ℚ := C ((682264250533 / 8639957931 : ℚ)) + C ((1364528501066 / 8639957931 : ℚ)) * X + C ((1812307334884 / 8639957931 : ℚ)) * X ^ 2 + C ((1843663517321 / 8639957931 : ℚ)) * X ^ 3 + C ((1687849015585 / 8639957931 : ℚ)) * X ^ 4 + C ((1009296368876 / 8639957931 : ℚ)) * X ^ 5 + C ((118410710730 / 2879985977 : ℚ)) * X ^ 6 + C ((-323320514519 / 8639957931 : ℚ)) * X ^ 7 + C ((-159711672085 / 2879985977 : ℚ)) * X ^ 8 + C ((-447778833818 / 8639957931 : ℚ)) * X ^ 9
theorem CW_111_6_neg_re : -CW_3_re_111 = CW_111_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_111, CW_111_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_6_neg_im : -CW_3_im_111 = CW_111_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_111, CW_111_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_111_6_mul : -CW_3_c_111 = ofLadj CW_111_6_pre CW_111_6_pim := by
  rw [CW_3_c_111, ofLadj_neg, CW_111_6_neg_re, CW_111_6_neg_im]

theorem CW_111_7_mul : CW_3_c_110 = ofLadj CW_3_re_110 CW_3_im_110 := rfl

@[expose] public def CW_coeff_111 : Ki := CW_0_c_100 * Fplus_dU_c_011 + CW_0_c_010 * Fplus_dU_c_101 + CW_1_c_100 * Fplus_dV_c_011 + CW_1_c_010 * Fplus_dV_c_101 + CW_2_c_100 * Fplus_dW_c_011 + CW_2_c_010 * Fplus_dW_c_101 + (-CW_3_c_111) + CW_3_c_110

theorem CW_coeff_111_sum :
    CW_coeff_111 = ofLadj (CW_111_0_pre + CW_111_1_pre + CW_111_2_pre + CW_111_3_pre + CW_111_4_pre + CW_111_5_pre + CW_111_6_pre + CW_3_re_110) (CW_111_0_pim + CW_111_1_pim + CW_111_2_pim + CW_111_3_pim + CW_111_4_pim + CW_111_5_pim + CW_111_6_pim + CW_3_im_110) := by
  simp only [CW_coeff_111, CW_111_0_mul, CW_111_1_mul, CW_111_2_mul, CW_111_3_mul, CW_111_4_mul, CW_111_5_mul, CW_111_6_mul, CW_111_7_mul]
  simp [ofLadj_add, add_assoc]

def CW_111_qre : Polynomial ℚ := C ((-4884102266795 / 8639957931 : ℚ)) + C ((40190708213663 / 8639957931 : ℚ)) * X + C ((31003757414764 / 8639957931 : ℚ)) * X ^ 2 + C ((51528021829085 / 8639957931 : ℚ)) * X ^ 3 + C ((67535952361670 / 8639957931 : ℚ)) * X ^ 4 + C ((35156937582829 / 8639957931 : ℚ)) * X ^ 5 + C ((14039878990349 / 2879985977 : ℚ)) * X ^ 6 + C ((21712791987599 / 8639957931 : ℚ)) * X ^ 7 + C ((-9750387784097 / 8639957931 : ℚ)) * X ^ 8
def CW_111_qim : Polynomial ℚ := C ((-33938149554941 / 8639957931 : ℚ)) + C ((-33938149554941 / 8639957931 : ℚ)) * X + C ((-4450210035446 / 2879985977 : ℚ)) * X ^ 2 + C ((-10457751893029 / 2879985977 : ℚ)) * X ^ 3 + C ((5901531173336 / 2879985977 : ℚ)) * X ^ 4 + C ((25342136422741 / 8639957931 : ℚ)) * X ^ 5 + C ((24295647082045 / 8639957931 : ℚ)) * X ^ 6 + C ((15877573174285 / 2879985977 : ℚ)) * X ^ 7 + C ((8408109777691 / 2879985977 : ℚ)) * X ^ 8
theorem CW_coeff_111_poly_re :
    CW_111_0_pre + CW_111_1_pre + CW_111_2_pre + CW_111_3_pre + CW_111_4_pre + CW_111_5_pre + CW_111_6_pre + CW_3_re_110 = (0 : Polynomial ℚ) + Phi11 * CW_111_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_111_0_pre, CW_111_1_pre, CW_111_2_pre, CW_111_3_pre, CW_111_4_pre, CW_111_5_pre, CW_111_6_pre, CW_3_re_110, CW_111_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_111_poly_im :
    CW_111_0_pim + CW_111_1_pim + CW_111_2_pim + CW_111_3_pim + CW_111_4_pim + CW_111_5_pim + CW_111_6_pim + CW_3_im_110 = (0 : Polynomial ℚ) + Phi11 * CW_111_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_111_0_pim, CW_111_1_pim, CW_111_2_pim, CW_111_3_pim, CW_111_4_pim, CW_111_5_pim, CW_111_6_pim, CW_3_im_110, CW_111_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_111_eq :
    CW_coeff_111 = (0 : Ki) := by
  rw [CW_coeff_111_sum, CW_coeff_111_poly_re,
    CW_coeff_111_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
