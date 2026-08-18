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

def CV_112_0_pre : Polynomial ℚ := C ((-1017963132832 / 8639957931 : ℚ)) + C ((12223952226560 / 8639957931 : ℚ)) * X + C ((23179799187562 / 8639957931 : ℚ)) * X ^ 2 + C ((39831748857014 / 8639957931 : ℚ)) * X ^ 3 + C ((59681502198374 / 8639957931 : ℚ)) * X ^ 4 + C ((23617401035730 / 2879985977 : ℚ)) * X ^ 5 + C ((79611190502686 / 8639957931 : ℚ)) * X ^ 6 + C ((2581372855882 / 261816907 : ℚ)) * X ^ 7 + C ((26670999204354 / 2879985977 : ℚ)) * X ^ 8 + C ((26015030728641 / 2879985977 : ℚ)) * X ^ 9 + C ((77259881215639 / 8639957931 : ℚ)) * X ^ 10 + C ((77347196521412 / 8639957931 : ℚ)) * X ^ 11 + C ((65035928989079 / 8639957931 : ℚ)) * X ^ 12 + C ((54865292998361 / 8639957931 : ℚ)) * X ^ 13 + C ((40181248756048 / 8639957931 : ℚ)) * X ^ 14 + C ((21524046566174 / 8639957931 : ℚ)) * X ^ 15 + C ((3778052415284 / 2879985977 : ℚ)) * X ^ 16 + C ((2575169850356 / 8639957931 : ℚ)) * X ^ 17 + C ((-3979755479558 / 8639957931 : ℚ)) * X ^ 18
def CV_112_0_pim : Polynomial ℚ := C ((-9031850998216 / 8639957931 : ℚ)) + C ((-18063701996432 / 8639957931 : ℚ)) * X + C ((-20885137913170 / 8639957931 : ℚ)) * X ^ 2 + C ((-2272448588678 / 785450721 : ℚ)) * X ^ 3 + C ((-19989341114936 / 8639957931 : ℚ)) * X ^ 4 + C ((-7221302662502 / 8639957931 : ℚ)) * X ^ 5 + C ((-56639183588 / 785450721 : ℚ)) * X ^ 6 + C ((4882835889252 / 2879985977 : ℚ)) * X ^ 7 + C ((20872613573236 / 8639957931 : ℚ)) * X ^ 8 + C ((20980605151741 / 8639957931 : ℚ)) * X ^ 9 + C ((6571357514565 / 2879985977 : ℚ)) * X ^ 10 + C ((9090010508776 / 2879985977 : ℚ)) * X ^ 11 + C ((11608663502987 / 2879985977 : ℚ)) * X ^ 12 + C ((3307353983423 / 785450721 : ℚ)) * X ^ 13 + C ((40600681958446 / 8639957931 : ℚ)) * X ^ 14 + C ((11953253734646 / 2879985977 : ℚ)) * X ^ 15 + C ((24918744592642 / 8639957931 : ℚ)) * X ^ 16 + C ((6467316715184 / 2879985977 : ℚ)) * X ^ 17 + C ((16411661982 / 23801537 : ℚ)) * X ^ 18
theorem CV_112_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_011 - CV_0_im_101 * Fplus_dU_im_011 = CV_112_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101, CV_0_im_101, Fplus_dU_re_011, Fplus_dU_im_011, CV_112_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_011 + CV_0_im_101 * Fplus_dU_re_011 = CV_112_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101, CV_0_im_101, Fplus_dU_re_011, Fplus_dU_im_011, CV_112_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_0_mul :
    CV_0_c_101 * Fplus_dU_c_011 = ofLadj CV_112_0_pre CV_112_0_pim := by
  rw [CV_0_c_101, Fplus_dU_c_011, ofLadj_mul, CV_112_0_pre_eq, CV_112_0_pim_eq]

def CV_112_1_pre : Polynomial ℚ := C ((1249543781276 / 2879985977 : ℚ)) + C ((-17366597255840 / 261816907 : ℚ)) * X + C ((-382056488395740 / 2879985977 : ℚ)) * X ^ 2 + C ((-622527269970002 / 2879985977 : ℚ)) * X ^ 3 + C ((-1052382879284268 / 2879985977 : ℚ)) * X ^ 4 + C ((-4041906434540188 / 8639957931 : ℚ)) * X ^ 5 + C ((-4874255347297858 / 8639957931 : ℚ)) * X ^ 6 + C ((-5236711432221092 / 8639957931 : ℚ)) * X ^ 7 + C ((-4874474880084514 / 8639957931 : ℚ)) * X ^ 8 + C ((-1538447022811048 / 2879985977 : ℚ)) * X ^ 9 + C ((-4417339116008536 / 8639957931 : ℚ)) * X ^ 10 + C ((-4347423064489948 / 8639957931 : ℚ)) * X ^ 11 + C ((-3844241406565816 / 8639957931 : ℚ)) * X ^ 12 + C ((-1156390534415308 / 2879985977 : ℚ)) * X ^ 13 + C ((-3006893070174508 / 8639957931 : ℚ)) * X ^ 14 + C ((-1955629276550456 / 8639957931 : ℚ)) * X ^ 15 + C ((-404152212874004 / 2879985977 : ℚ)) * X ^ 16 + C ((-126702575288114 / 2879985977 : ℚ)) * X ^ 17 + C ((41311172605944 / 2879985977 : ℚ)) * X ^ 18
def CV_112_1_pim : Polynomial ℚ := C ((181155694654556 / 2879985977 : ℚ)) + C ((362311389309112 / 2879985977 : ℚ)) * X + C ((468356885208420 / 2879985977 : ℚ)) * X ^ 2 + C ((1927341321496510 / 8639957931 : ℚ)) * X ^ 3 + C ((1938543234883624 / 8639957931 : ℚ)) * X ^ 4 + C ((474571881615024 / 2879985977 : ℚ)) * X ^ 5 + C ((284378347105950 / 2879985977 : ℚ)) * X ^ 6 + C ((-240626186337056 / 8639957931 : ℚ)) * X ^ 7 + C ((-834795368302802 / 8639957931 : ℚ)) * X ^ 8 + C ((-797380952762132 / 8639957931 : ℚ)) * X ^ 9 + C ((-625952165785556 / 8639957931 : ℚ)) * X ^ 10 + C ((-918130013212232 / 8639957931 : ℚ)) * X ^ 11 + C ((-1210307860638908 / 8639957931 : ℚ)) * X ^ 12 + C ((-1357015561360256 / 8639957931 : ℚ)) * X ^ 13 + C ((-613957270563612 / 2879985977 : ℚ)) * X ^ 14 + C ((-59454503407120 / 261816907 : ℚ)) * X ^ 15 + C ((-1667325974913004 / 8639957931 : ℚ)) * X ^ 16 + C ((-452950189915682 / 2879985977 : ℚ)) * X ^ 17 + C ((-161748098202912 / 2879985977 : ℚ)) * X ^ 18
theorem CV_112_1_pre_eq :
    CV_0_re_002 * Fplus_dU_re_110 - CV_0_im_002 * Fplus_dU_im_110 = CV_112_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002, CV_0_im_002, Fplus_dU_re_110, Fplus_dU_im_110, CV_112_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_1_pim_eq :
    CV_0_re_002 * Fplus_dU_im_110 + CV_0_im_002 * Fplus_dU_re_110 = CV_112_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002, CV_0_im_002, Fplus_dU_re_110, Fplus_dU_im_110, CV_112_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_1_mul :
    CV_0_c_002 * Fplus_dU_c_110 = ofLadj CV_112_1_pre CV_112_1_pim := by
  rw [CV_0_c_002, Fplus_dU_c_110, ofLadj_mul, CV_112_1_pre_eq, CV_112_1_pim_eq]

def CV_112_2_pre : Polynomial ℚ := C ((13037393852 / 32359393 : ℚ)) + C ((189596396920 / 8825289 : ℚ)) * X + C ((367083327467 / 8825289 : ℚ)) * X ^ 2 + C ((2243020573601 / 32359393 : ℚ)) * X ^ 3 + C ((10069129679146 / 97078179 : ℚ)) * X ^ 4 + C ((11975937495385 / 97078179 : ℚ)) * X ^ 5 + C ((13548860963026 / 97078179 : ℚ)) * X ^ 6 + C ((14521060919419 / 97078179 : ℚ)) * X ^ 7 + C ((13754339126738 / 97078179 : ℚ)) * X ^ 8 + C ((4533172196595 / 32359393 : ℚ)) * X ^ 9 + C ((13474317382199 / 97078179 : ℚ)) * X ^ 10 + C ((4464921385532 / 32359393 : ℚ)) * X ^ 11 + C ((3796252338693 / 32359393 : ℚ)) * X ^ 12 + C ((9561599987648 / 97078179 : ℚ)) * X ^ 13 + C ((7025277405935 / 97078179 : ℚ)) * X ^ 14 + C ((3833324497060 / 97078179 : ℚ)) * X ^ 15 + C ((2011784110426 / 97078179 : ℚ)) * X ^ 16 + C ((438860642785 / 97078179 : ℚ)) * X ^ 17 + C ((-618606743213 / 97078179 : ℚ)) * X ^ 18
def CV_112_2_pim : Polynomial ℚ := C ((-1464818101184 / 97078179 : ℚ)) + C ((-2929636202368 / 97078179 : ℚ)) * X + C ((-1131697437349 / 32359393 : ℚ)) * X ^ 2 + C ((-4130816132119 / 97078179 : ℚ)) * X ^ 3 + C ((-1065423053012 / 32359393 : ℚ)) * X ^ 4 + C ((-421012659097 / 32359393 : ℚ)) * X ^ 5 + C ((55753807730 / 32359393 : ℚ)) * X ^ 6 + C ((855962929177 / 32359393 : ℚ)) * X ^ 7 + C ((1282570202070 / 32359393 : ℚ)) * X ^ 8 + C ((3821055729449 / 97078179 : ℚ)) * X ^ 9 + C ((3718663127005 / 97078179 : ℚ)) * X ^ 10 + C ((5029154488334 / 97078179 : ℚ)) * X ^ 11 + C ((2113215283221 / 32359393 : ℚ)) * X ^ 12 + C ((6702709356898 / 97078179 : ℚ)) * X ^ 13 + C ((7411778300209 / 97078179 : ℚ)) * X ^ 14 + C ((6548631939298 / 97078179 : ℚ)) * X ^ 15 + C ((1581475924332 / 32359393 : ℚ)) * X ^ 16 + C ((1160007185135 / 32359393 : ℚ)) * X ^ 17 + C ((1208421206507 / 97078179 : ℚ)) * X ^ 18
theorem CV_112_2_pre_eq :
    CV_1_re_101 * Fplus_dV_re_011 - CV_1_im_101 * Fplus_dV_im_011 = CV_112_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101, CV_1_im_101, Fplus_dV_re_011, Fplus_dV_im_011, CV_112_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_2_pim_eq :
    CV_1_re_101 * Fplus_dV_im_011 + CV_1_im_101 * Fplus_dV_re_011 = CV_112_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101, CV_1_im_101, Fplus_dV_re_011, Fplus_dV_im_011, CV_112_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_2_mul :
    CV_1_c_101 * Fplus_dV_c_011 = ofLadj CV_112_2_pre CV_112_2_pim := by
  rw [CV_1_c_101, Fplus_dV_c_011, ofLadj_mul, CV_112_2_pre_eq, CV_112_2_pim_eq]

def CV_112_3_pre : Polynomial ℚ := C ((-2068690893106 / 8639957931 : ℚ)) + C ((-1086208130465000 / 8639957931 : ℚ)) * X + C ((-2058327624466928 / 8639957931 : ℚ)) * X ^ 2 + C ((-3542295805667018 / 8639957931 : ℚ)) * X ^ 3 + C ((-5780457822494444 / 8639957931 : ℚ)) * X ^ 4 + C ((-7458832316421602 / 8639957931 : ℚ)) * X ^ 5 + C ((-9092560846805362 / 8639957931 : ℚ)) * X ^ 6 + C ((-10409603583626818 / 8639957931 : ℚ)) * X ^ 7 + C ((-3528265727306960 / 2879985977 : ℚ)) * X ^ 8 + C ((-10954331820862678 / 8639957931 : ℚ)) * X ^ 9 + C ((-3745300037776376 / 2879985977 : ℚ)) * X ^ 10 + C ((-3779760976913828 / 2879985977 : ℚ)) * X ^ 11 + C ((-10149691982864128 / 8639957931 : ℚ)) * X ^ 12 + C ((-8896004196395750 / 8639957931 : ℚ)) * X ^ 13 + C ((-7042501376253862 / 8639957931 : ℚ)) * X ^ 14 + C ((-4465162499985610 / 8639957931 : ℚ)) * X ^ 15 + C ((-240037169132 / 802299 : ℚ)) * X ^ 16 + C ((-951231743998748 / 8639957931 : ℚ)) * X ^ 17 + C ((163983261146764 / 8639957931 : ℚ)) * X ^ 18
def CV_112_3_pim : Polynomial ℚ := C ((30379900523770 / 261816907 : ℚ)) + C ((60759801047540 / 261816907 : ℚ)) * X + C ((2709752694703636 / 8639957931 : ℚ)) * X ^ 2 + C ((3805111780849882 / 8639957931 : ℚ)) * X ^ 3 + C ((1327196049415920 / 2879985977 : ℚ)) * X ^ 4 + C ((3540895255684730 / 8639957931 : ℚ)) * X ^ 5 + C ((3103863405351286 / 8639957931 : ℚ)) * X ^ 6 + C ((1849423308487774 / 8639957931 : ℚ)) * X ^ 7 + C ((948460723211792 / 8639957931 : ℚ)) * X ^ 8 + C ((895514683889638 / 8639957931 : ℚ)) * X ^ 9 + C ((651089976485308 / 8639957931 : ℚ)) * X ^ 10 + C ((-709324873880860 / 8639957931 : ℚ)) * X ^ 11 + C ((-689913241415676 / 2879985977 : ℚ)) * X ^ 12 + C ((-3018843691786174 / 8639957931 : ℚ)) * X ^ 13 + C ((-4167148817254574 / 8639957931 : ℚ)) * X ^ 14 + C ((-4188910761767350 / 8639957931 : ℚ)) * X ^ 15 + C ((-3434097251645972 / 8639957931 : ℚ)) * X ^ 16 + C ((-874745907527648 / 2879985977 : ℚ)) * X ^ 17 + C ((-1055677008161084 / 8639957931 : ℚ)) * X ^ 18
theorem CV_112_3_pre_eq :
    CV_1_re_002 * Fplus_dV_re_110 - CV_1_im_002 * Fplus_dV_im_110 = CV_112_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002, CV_1_im_002, Fplus_dV_re_110, Fplus_dV_im_110, CV_112_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_3_pim_eq :
    CV_1_re_002 * Fplus_dV_im_110 + CV_1_im_002 * Fplus_dV_re_110 = CV_112_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002, CV_1_im_002, Fplus_dV_re_110, Fplus_dV_im_110, CV_112_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_3_mul :
    CV_1_c_002 * Fplus_dV_c_110 = ofLadj CV_112_3_pre CV_112_3_pim := by
  rw [CV_1_c_002, Fplus_dV_c_110, ofLadj_mul, CV_112_3_pre_eq, CV_112_3_pim_eq]

def CV_112_4_pre : Polynomial ℚ := C ((339929290 / 2941763 : ℚ)) + C ((-21472258208440 / 8639957931 : ℚ)) * X + C ((-45797223732428 / 8639957931 : ℚ)) * X ^ 2 + C ((-26096055424503 / 2879985977 : ℚ)) * X ^ 3 + C ((-124638485382941 / 8639957931 : ℚ)) * X ^ 4 + C ((-161220570057746 / 8639957931 : ℚ)) * X ^ 5 + C ((-17266968856883 / 785450721 : ℚ)) * X ^ 6 + C ((-198402980189800 / 8639957931 : ℚ)) * X ^ 7 + C ((-179281600559768 / 8639957931 : ℚ)) * X ^ 8 + C ((-55276110312450 / 2879985977 : ℚ)) * X ^ 9 + C ((-155622048042536 / 8639957931 : ℚ)) * X ^ 10 + C ((-152797451146886 / 8639957931 : ℚ)) * X ^ 11 + C ((-134149789834096 / 8639957931 : ℚ)) * X ^ 12 + C ((-1348664125898 / 97078179 : ℚ)) * X ^ 13 + C ((-100993434286259 / 8639957931 : ℚ)) * X ^ 14 + C ((-67005815914217 / 8639957931 : ℚ)) * X ^ 15 + C ((-12595985846195 / 2879985977 : ℚ)) * X ^ 16 + C ((-9071870170618 / 8639957931 : ℚ)) * X ^ 17 + C ((2252892964214 / 2879985977 : ℚ)) * X ^ 18
def CV_112_4_pim : Polynomial ℚ := C ((23063867427650 / 8639957931 : ℚ)) + C ((46127734855300 / 8639957931 : ℚ)) * X + C ((19046632925978 / 2879985977 : ℚ)) * X ^ 2 + C ((72572977253873 / 8639957931 : ℚ)) * X ^ 3 + C ((71057446349851 / 8639957931 : ℚ)) * X ^ 4 + C ((16726973224234 / 2879985977 : ℚ)) * X ^ 5 + C ((7101040344483 / 2879985977 : ℚ)) * X ^ 6 + C ((-6179629404470 / 2879985977 : ℚ)) * X ^ 7 + C ((-40504194555118 / 8639957931 : ℚ)) * X ^ 8 + C ((-38525370259012 / 8639957931 : ℚ)) * X ^ 9 + C ((-29626624364566 / 8639957931 : ℚ)) * X ^ 10 + C ((-13233008968016 / 2879985977 : ℚ)) * X ^ 11 + C ((-49771429443530 / 8639957931 : ℚ)) * X ^ 12 + C ((-51884847471718 / 8639957931 : ℚ)) * X ^ 13 + C ((-21779700550517 / 2879985977 : ℚ)) * X ^ 14 + C ((-6314766582913 / 785450721 : ℚ)) * X ^ 15 + C ((-60009351418133 / 8639957931 : ℚ)) * X ^ 16 + C ((-14915002746938 / 2879985977 : ℚ)) * X ^ 17 + C ((-16326444677194 / 8639957931 : ℚ)) * X ^ 18
theorem CV_112_4_pre_eq :
    CV_2_re_101 * Fplus_dW_re_011 - CV_2_im_101 * Fplus_dW_im_011 = CV_112_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101, CV_2_im_101, Fplus_dW_re_011, Fplus_dW_im_011, CV_112_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_4_pim_eq :
    CV_2_re_101 * Fplus_dW_im_011 + CV_2_im_101 * Fplus_dW_re_011 = CV_112_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101, CV_2_im_101, Fplus_dW_re_011, Fplus_dW_im_011, CV_112_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_4_mul :
    CV_2_c_101 * Fplus_dW_c_011 = ofLadj CV_112_4_pre CV_112_4_pim := by
  rw [CV_2_c_101, Fplus_dW_c_011, ofLadj_mul, CV_112_4_pre_eq, CV_112_4_pim_eq]

def CV_112_5_pre : Polynomial ℚ := C ((-58117182066712 / 8639957931 : ℚ)) + C ((-814023158925280 / 8639957931 : ℚ)) * X + C ((-1654353907651276 / 8639957931 : ℚ)) * X ^ 2 + C ((-907025960333728 / 2879985977 : ℚ)) * X ^ 3 + C ((-4051710637456888 / 8639957931 : ℚ)) * X ^ 4 + C ((-4814861843185676 / 8639957931 : ℚ)) * X ^ 5 + C ((-1809746068971560 / 2879985977 : ℚ)) * X ^ 6 + C ((-1922346154505068 / 2879985977 : ℚ)) * X ^ 7 + C ((-5493029773946272 / 8639957931 : ℚ)) * X ^ 8 + C ((-5388726832831280 / 8639957931 : ℚ)) * X ^ 9 + C ((-5309815716070322 / 8639957931 : ℚ)) * X ^ 10 + C ((-5221645194423508 / 8639957931 : ℚ)) * X ^ 11 + C ((-4495792557145042 / 8639957931 : ℚ)) * X ^ 12 + C ((-3734372925180004 / 8639957931 : ℚ)) * X ^ 13 + C ((-2771951892945088 / 8639957931 : ℚ)) * X ^ 14 + C ((-1536576694457824 / 8639957931 : ℚ)) * X ^ 15 + C ((-830327855144320 / 8639957931 : ℚ)) * X ^ 16 + C ((-71983830471772 / 2879985977 : ℚ)) * X ^ 17 + C ((16250102872772 / 785450721 : ℚ)) * X ^ 18
def CV_112_5_pim : Polynomial ℚ := C ((182997493960696 / 2879985977 : ℚ)) + C ((365994987921392 / 2879985977 : ℚ)) * X + C ((1302198013515436 / 8639957931 : ℚ)) * X ^ 2 + C ((511470793368936 / 2879985977 : ℚ)) * X ^ 3 + C ((1155398108574992 / 8639957931 : ℚ)) * X ^ 4 + C ((402765738619720 / 8639957931 : ℚ)) * X ^ 5 + C ((-197074462520524 / 8639957931 : ℚ)) * X ^ 6 + C ((-1083557590807540 / 8639957931 : ℚ)) * X ^ 7 + C ((-1589462856537676 / 8639957931 : ℚ)) * X ^ 8 + C ((-1574831854848532 / 8639957931 : ℚ)) * X ^ 9 + C ((-501953612279098 / 2879985977 : ℚ)) * X ^ 10 + C ((-651393512311648 / 2879985977 : ℚ)) * X ^ 11 + C ((-800833412344198 / 2879985977 : ℚ)) * X ^ 12 + C ((-845914089590872 / 2879985977 : ℚ)) * X ^ 13 + C ((-2755325633674844 / 8639957931 : ℚ)) * X ^ 14 + C ((-806508744401000 / 2879985977 : ℚ)) * X ^ 15 + C ((-1755696895063744 / 8639957931 : ℚ)) * X ^ 16 + C ((-1260370491141164 / 8639957931 : ℚ)) * X ^ 17 + C ((-462690394670164 / 8639957931 : ℚ)) * X ^ 18
theorem CV_112_5_pre_eq :
    CV_2_re_002 * Fplus_dW_re_110 - CV_2_im_002 * Fplus_dW_im_110 = CV_112_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002, CV_2_im_002, Fplus_dW_re_110, Fplus_dW_im_110, CV_112_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_5_pim_eq :
    CV_2_re_002 * Fplus_dW_im_110 + CV_2_im_002 * Fplus_dW_re_110 = CV_112_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002, CV_2_im_002, Fplus_dW_re_110, Fplus_dW_im_110, CV_112_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_112_5_mul :
    CV_2_c_002 * Fplus_dW_c_110 = ofLadj CV_112_5_pre CV_112_5_pim := by
  rw [CV_2_c_002, Fplus_dW_c_110, ofLadj_mul, CV_112_5_pre_eq, CV_112_5_pim_eq]

theorem CV_112_6_mul : CV_3_c_102 = ofLadj CV_3_re_102 CV_3_im_102 := rfl

@[expose] public def CV_coeff_112 : Ki := CV_0_c_101 * Fplus_dU_c_011 + CV_0_c_002 * Fplus_dU_c_110 + CV_1_c_101 * Fplus_dV_c_011 + CV_1_c_002 * Fplus_dV_c_110 + CV_2_c_101 * Fplus_dW_c_011 + CV_2_c_002 * Fplus_dW_c_110 + CV_3_c_102

theorem CV_coeff_112_sum :
    CV_coeff_112 = ofLadj (CV_112_0_pre + CV_112_1_pre + CV_112_2_pre + CV_112_3_pre + CV_112_4_pre + CV_112_5_pre + CV_3_re_102) (CV_112_0_pim + CV_112_1_pim + CV_112_2_pim + CV_112_3_pim + CV_112_4_pim + CV_112_5_pim + CV_3_im_102) := by
  simp only [CV_coeff_112, CV_112_0_mul, CV_112_1_mul, CV_112_2_mul, CV_112_3_mul, CV_112_4_mul, CV_112_5_mul, CV_112_6_mul]
  simp [ofLadj_add, add_assoc]

def CV_112_qre : Polynomial ℚ := C ((-50535430875802 / 8639957931 : ℚ)) + C ((-748809000451466 / 2879985977 : ℚ)) * X + C ((-2231508292861405 / 8639957931 : ℚ)) * X ^ 2 + C ((-3056823304352113 / 8639957931 : ℚ)) * X ^ 3 + C ((-4595224475671861 / 8639957931 : ℚ)) * X ^ 4 + C ((-289684961589994 / 785450721 : ℚ)) * X ^ 5 + C ((-2960420718222856 / 8639957931 : ℚ)) * X ^ 6 + C ((-1929119898223018 / 8639957931 : ℚ)) * X ^ 7 + C ((414390833832215 / 8639957931 : ℚ)) * X ^ 8
def CV_112_qim : Polynomial ℚ := C ((1986795110289062 / 8639957931 : ℚ)) + C ((1986795110289062 / 8639957931 : ℚ)) * X + C ((399766520858699 / 2879985977 : ℚ)) * X ^ 2 + C ((598957356928523 / 2879985977 : ℚ)) * X ^ 3 + C ((-36075459192955 / 2879985977 : ℚ)) * X ^ 4 + C ((-141023034487666 / 785450721 : ℚ)) * X ^ 5 + C ((-503625577838732 / 2879985977 : ℚ)) * X ^ 6 + C ((-3052648701696782 / 8639957931 : ℚ)) * X ^ 7 + C ((-635477073812863 / 2879985977 : ℚ)) * X ^ 8
theorem CV_coeff_112_poly_re :
    CV_112_0_pre + CV_112_1_pre + CV_112_2_pre + CV_112_3_pre + CV_112_4_pre + CV_112_5_pre + CV_3_re_102 = (0 : Polynomial ℚ) + Phi11 * CV_112_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_112_0_pre, CV_112_1_pre, CV_112_2_pre, CV_112_3_pre, CV_112_4_pre, CV_112_5_pre, CV_3_re_102, CV_112_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_112_poly_im :
    CV_112_0_pim + CV_112_1_pim + CV_112_2_pim + CV_112_3_pim + CV_112_4_pim + CV_112_5_pim + CV_3_im_102 = (0 : Polynomial ℚ) + Phi11 * CV_112_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_112_0_pim, CV_112_1_pim, CV_112_2_pim, CV_112_3_pim, CV_112_4_pim, CV_112_5_pim, CV_3_im_102, CV_112_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_112_eq :
    CV_coeff_112 = (0 : Ki) := by
  rw [CV_coeff_112_sum, CV_coeff_112_poly_re,
    CV_coeff_112_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
