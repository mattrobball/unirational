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

def CV_111_0_pre : Polynomial ℚ := C ((31345943690 / 785450721 : ℚ)) + C ((9574596444760 / 8639957931 : ℚ)) * X + C ((6270384964582 / 2879985977 : ℚ)) * X ^ 2 + C ((31083499809548 / 8639957931 : ℚ)) * X ^ 3 + C ((46910699934184 / 8639957931 : ℚ)) * X ^ 4 + C ((55472153502184 / 8639957931 : ℚ)) * X ^ 5 + C ((62823850998562 / 8639957931 : ℚ)) * X ^ 6 + C ((22104766669531 / 2879985977 : ℚ)) * X ^ 7 + C ((21065785019772 / 2879985977 : ℚ)) * X ^ 8 + C ((61948376374388 / 8639957931 : ℚ)) * X ^ 9 + C ((20359943232910 / 2879985977 : ℚ)) * X ^ 10 + C ((60385417000952 / 8639957931 : ℚ)) * X ^ 11 + C ((51505233253970 / 8639957931 : ℚ)) * X ^ 12 + C ((43137221480642 / 8639957931 : ℚ)) * X ^ 13 + C ((32113855249768 / 8639957931 : ℚ)) * X ^ 14 + C ((5799248461599 / 2879985977 : ℚ)) * X ^ 15 + C ((863052364244 / 785450721 : ℚ)) * X ^ 16 + C ((2141878510306 / 8639957931 : ℚ)) * X ^ 17 + C ((-2005854689612 / 8639957931 : ℚ)) * X ^ 18
def CV_111_0_pim : Polynomial ℚ := C ((-2199480918202 / 2879985977 : ℚ)) + C ((-4398961836404 / 2879985977 : ℚ)) * X + C ((-1382317571584 / 785450721 : ℚ)) * X ^ 2 + C ((-18748512388942 / 8639957931 : ℚ)) * X ^ 3 + C ((-14118547875668 / 8639957931 : ℚ)) * X ^ 4 + C ((-5531317010672 / 8639957931 : ℚ)) * X ^ 5 + C ((475126817832 / 2879985977 : ℚ)) * X ^ 6 + C ((11680991918683 / 8639957931 : ℚ)) * X ^ 7 + C ((17170524819488 / 8639957931 : ℚ)) * X ^ 8 + C ((140247969832 / 71404611 : ℚ)) * X ^ 9 + C ((16151141311180 / 8639957931 : ℚ)) * X ^ 10 + C ((21604609256558 / 8639957931 : ℚ)) * X ^ 11 + C ((819941733392 / 261816907 : ℚ)) * X ^ 12 + C ((28247821941656 / 8639957931 : ℚ)) * X ^ 13 + C ((10530106857786 / 2879985977 : ℚ)) * X ^ 14 + C ((27485036871667 / 8639957931 : ℚ)) * X ^ 15 + C ((19930171890230 / 8639957931 : ℚ)) * X ^ 16 + C ((14188097670850 / 8639957931 : ℚ)) * X ^ 17 + C ((4964852089222 / 8639957931 : ℚ)) * X ^ 18
theorem CV_111_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_011 - CV_0_im_100 * Fplus_dU_im_011 = CV_111_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_111_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_011 + CV_0_im_100 * Fplus_dU_re_011 = CV_111_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_111_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_0_mul :
    CV_0_c_100 * Fplus_dU_c_011 = ofLadj CV_111_0_pre CV_111_0_pim := by
  rw [CV_0_c_100_def, Fplus_dU_c_011_def, ofLadj_mul, CV_111_0_pre_eq, CV_111_0_pim_eq]

def CV_111_1_pre : Polynomial ℚ := C ((-835084249078 / 2879985977 : ℚ)) + C ((396838302772160 / 8639957931 : ℚ)) * X + C ((793955280280099 / 8639957931 : ℚ)) * X ^ 2 + C ((3564052354325 / 23801537 : ℚ)) * X ^ 3 + C ((2186853921560672 / 8639957931 : ℚ)) * X ^ 4 + C ((933149744888060 / 2879985977 : ℚ)) * X ^ 5 + C ((3376090760604277 / 8639957931 : ℚ)) * X ^ 6 + C ((1209043507896786 / 2879985977 : ℚ)) * X ^ 7 + C ((306926279997071 / 785450721 : ℚ)) * X ^ 8 + C ((3196927650876704 / 8639957931 : ℚ)) * X ^ 9 + C ((3059569883604161 / 8639957931 : ℚ)) * X ^ 10 + C ((1003792514080134 / 2879985977 : ℚ)) * X ^ 11 + C ((887577193610667 / 2879985977 : ℚ)) * X ^ 12 + C ((2402972370596605 / 8639957931 : ℚ)) * X ^ 13 + C ((189312552304346 / 785450721 : ℚ)) * X ^ 14 + C ((1354570665502759 / 8639957931 : ℚ)) * X ^ 15 + C ((839975329021360 / 8639957931 : ℚ)) * X ^ 16 + C ((87777934360421 / 2879985977 : ℚ)) * X ^ 17 + C ((-28568645542309 / 2879985977 : ℚ)) * X ^ 18
def CV_111_1_pim : Polynomial ℚ := C ((-376294894480004 / 8639957931 : ℚ)) + C ((-752589788960008 / 8639957931 : ℚ)) * X + C ((-324294934345111 / 2879985977 : ℚ)) * X ^ 2 + C ((-1334618668609807 / 8639957931 : ℚ)) * X ^ 3 + C ((-447341714432240 / 2879985977 : ℚ)) * X ^ 4 + C ((-29875596357572 / 261816907 : ℚ)) * X ^ 5 + C ((-196799046566281 / 2879985977 : ℚ)) * X ^ 6 + C ((55725840658080 / 2879985977 : ℚ)) * X ^ 7 + C ((192981668498303 / 2879985977 : ℚ)) * X ^ 8 + C ((552911803430056 / 8639957931 : ℚ)) * X ^ 9 + C ((434214762313381 / 8639957931 : ℚ)) * X ^ 10 + C ((636486058036480 / 8639957931 : ℚ)) * X ^ 11 + C ((838757353759579 / 8639957931 : ℚ)) * X ^ 12 + C ((313451775572743 / 2879985977 : ℚ)) * X ^ 13 + C ((1276055990227850 / 8639957931 : ℚ)) * X ^ 14 + C ((1359004331118091 / 8639957931 : ℚ)) * X ^ 15 + C ((1155250169761514 / 8639957931 : ℚ)) * X ^ 16 + C ((941423976850157 / 8639957931 : ℚ)) * X ^ 17 + C ((112075205772447 / 2879985977 : ℚ)) * X ^ 18
theorem CV_111_1_pre_eq :
    CV_0_re_001 * Fplus_dU_re_110 - CV_0_im_001 * Fplus_dU_im_110 = CV_111_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_111_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_1_pim_eq :
    CV_0_re_001 * Fplus_dU_im_110 + CV_0_im_001 * Fplus_dU_re_110 = CV_111_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_111_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_1_mul :
    CV_0_c_001 * Fplus_dU_c_110 = ofLadj CV_111_1_pre CV_111_1_pim := by
  rw [CV_0_c_001_def, Fplus_dU_c_110_def, ofLadj_mul, CV_111_1_pre_eq, CV_111_1_pim_eq]

def CV_111_2_pre : Polynomial ℚ := C ((-7155705805780 / 8639957931 : ℚ)) + C ((-36656306680000 / 2879985977 : ℚ)) * X + C ((-217410548479126 / 8639957931 : ℚ)) * X ^ 2 + C ((-356821900283234 / 8639957931 : ℚ)) * X ^ 3 + C ((-48386483858762 / 785450721 : ℚ)) * X ^ 4 + C ((-210949851034075 / 2879985977 : ℚ)) * X ^ 5 + C ((-65169564378706 / 785450721 : ℚ)) * X ^ 6 + C ((-766731525101282 / 8639957931 : ℚ)) * X ^ 7 + C ((-243525016762873 / 2879985977 : ℚ)) * X ^ 8 + C ((-722271309182845 / 8639957931 : ℚ)) * X ^ 9 + C ((-238678561620699 / 2879985977 : ℚ)) * X ^ 10 + C ((-706433366512840 / 8639957931 : ℚ)) * X ^ 11 + C ((-202022254940699 / 2879985977 : ℚ)) * X ^ 12 + C ((-168286920234573 / 2879985977 : ℚ)) * X ^ 13 + C ((-373753150005385 / 8639957931 : ℚ)) * X ^ 14 + C ((-68622113804008 / 2879985977 : ℚ)) * X ^ 15 + C ((-109823618206438 / 8639957931 : ℚ)) * X ^ 16 + C ((-25807963142897 / 8639957931 : ℚ)) * X ^ 17 + C ((28613861242876 / 8639957931 : ℚ)) * X ^ 18
def CV_111_2_pim : Polynomial ℚ := C ((6830973383420 / 785450721 : ℚ)) + C ((13661946766840 / 785450721 : ℚ)) * X + C ((175563027886324 / 8639957931 : ℚ)) * X ^ 2 + C ((70520910241648 / 2879985977 : ℚ)) * X ^ 3 + C ((161709104397812 / 8639957931 : ℚ)) * X ^ 4 + C ((63343696003993 / 8639957931 : ℚ)) * X ^ 5 + C ((-16706519911316 / 8639957931 : ℚ)) * X ^ 6 + C ((-138057853141822 / 8639957931 : ℚ)) * X ^ 7 + C ((-208400675994461 / 8639957931 : ℚ)) * X ^ 8 + C ((-207148402549601 / 8639957931 : ℚ)) * X ^ 9 + C ((-67249278893551 / 2879985977 : ℚ)) * X ^ 10 + C ((-89618635709536 / 2879985977 : ℚ)) * X ^ 11 + C ((-111987992525521 / 2879985977 : ℚ)) * X ^ 12 + C ((-118615008386233 / 2879985977 : ℚ)) * X ^ 13 + C ((-390592454552459 / 8639957931 : ℚ)) * X ^ 14 + C ((-114758191549030 / 2879985977 : ℚ)) * X ^ 15 + C ((-252820198248956 / 8639957931 : ℚ)) * X ^ 16 + C ((-181247377665697 / 8639957931 : ℚ)) * X ^ 17 + C ((-66807076430876 / 8639957931 : ℚ)) * X ^ 18
theorem CV_111_2_pre_eq :
    CV_1_re_100 * Fplus_dV_re_011 - CV_1_im_100 * Fplus_dV_im_011 = CV_111_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_111_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_2_pim_eq :
    CV_1_re_100 * Fplus_dV_im_011 + CV_1_im_100 * Fplus_dV_re_011 = CV_111_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_111_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_2_mul :
    CV_1_c_100 * Fplus_dV_c_011 = ofLadj CV_111_2_pre CV_111_2_pim := by
  rw [CV_1_c_100_def, Fplus_dV_c_011_def, ofLadj_mul, CV_111_2_pre_eq, CV_111_2_pim_eq]

def CV_111_3_pre : Polynomial ℚ := C ((-379779255026 / 2879985977 : ℚ)) + C ((779062767906520 / 8639957931 : ℚ)) * X + C ((491095817832112 / 2879985977 : ℚ)) * X ^ 2 + C ((2539425604980455 / 8639957931 : ℚ)) * X ^ 3 + C ((1381559880700401 / 2879985977 : ℚ)) * X ^ 4 + C ((5348556770901266 / 8639957931 : ℚ)) * X ^ 5 + C ((2173378281372030 / 2879985977 : ℚ)) * X ^ 6 + C ((7465577173887878 / 8639957931 : ℚ)) * X ^ 7 + C ((7589469110508082 / 8639957931 : ℚ)) * X ^ 8 + C ((2618069489141272 / 2879985977 : ℚ)) * X ^ 9 + C ((8056804339850221 / 8639957931 : ℚ)) * X ^ 10 + C ((8132995451975450 / 8639957931 : ℚ)) * X ^ 11 + C ((2425913857314567 / 2879985977 : ℚ)) * X ^ 12 + C ((2126973671309160 / 2879985977 : ℚ)) * X ^ 13 + C ((5050043505527627 / 8639957931 : ℚ)) * X ^ 14 + C ((1066990967679707 / 2879985977 : ℚ)) * X ^ 15 + C ((20812788823540 / 97078179 : ℚ)) * X ^ 16 + C ((680760132080236 / 8639957931 : ℚ)) * X ^ 17 + C ((-119924628747554 / 8639957931 : ℚ)) * X ^ 18
def CV_111_3_pim : Polynomial ℚ := C ((-719822479115162 / 8639957931 : ℚ)) + C ((-1439644958230324 / 8639957931 : ℚ)) * X + C ((-1944437585107538 / 8639957931 : ℚ)) * X ^ 2 + C ((-910557085809265 / 2879985977 : ℚ)) * X ^ 3 + C ((-952873768248093 / 2879985977 : ℚ)) * X ^ 4 + C ((-21001005744848 / 71404611 : ℚ)) * X ^ 5 + C ((-743246839852138 / 2879985977 : ℚ)) * X ^ 6 + C ((-1327096193500442 / 8639957931 : ℚ)) * X ^ 7 + C ((-682298374306984 / 8639957931 : ℚ)) * X ^ 8 + C ((-643936610408320 / 8639957931 : ℚ)) * X ^ 9 + C ((-468693375530935 / 8639957931 : ℚ)) * X ^ 10 + C ((508013602902896 / 8639957931 : ℚ)) * X ^ 11 + C ((1484720581336727 / 8639957931 : ℚ)) * X ^ 12 + C ((721585481030442 / 2879985977 : ℚ)) * X ^ 13 + C ((2990351879310247 / 8639957931 : ℚ)) * X ^ 14 + C ((273264642738233 / 785450721 : ℚ)) * X ^ 15 + C ((2463369776919868 / 8639957931 : ℚ)) * X ^ 16 + C ((1883874685338622 / 8639957931 : ℚ)) * X ^ 17 + C ((756188675699626 / 8639957931 : ℚ)) * X ^ 18
theorem CV_111_3_pre_eq :
    CV_1_re_001 * Fplus_dV_re_110 - CV_1_im_001 * Fplus_dV_im_110 = CV_111_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_111_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_3_pim_eq :
    CV_1_re_001 * Fplus_dV_im_110 + CV_1_im_001 * Fplus_dV_re_110 = CV_111_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_111_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_3_mul :
    CV_1_c_001 * Fplus_dV_c_110 = ofLadj CV_111_3_pre CV_111_3_pim := by
  rw [CV_1_c_001_def, Fplus_dV_c_110_def, ofLadj_mul, CV_111_3_pre_eq, CV_111_3_pim_eq]

def CV_111_4_pre : Polynomial ℚ := C ((-490472006 / 8825289 : ℚ)) + C ((3360256546952 / 2879985977 : ℚ)) * X + C ((21450712182239 / 8639957931 : ℚ)) * X ^ 2 + C ((12186265802820 / 2879985977 : ℚ)) * X ^ 3 + C ((58284290779700 / 8639957931 : ℚ)) * X ^ 4 + C ((25126932767275 / 2879985977 : ℚ)) * X ^ 5 + C ((88802675918224 / 8639957931 : ℚ)) * X ^ 6 + C ((2808955737087 / 261816907 : ℚ)) * X ^ 7 + C ((83830756094179 / 8639957931 : ℚ)) * X ^ 8 + C ((25860022490723 / 2879985977 : ℚ)) * X ^ 9 + C ((72820424491399 / 8639957931 : ℚ)) * X ^ 10 + C ((71487679433342 / 8639957931 : ℚ)) * X ^ 11 + C ((5703604986413 / 785450721 : ℚ)) * X ^ 12 + C ((630666913370 / 97078179 : ℚ)) * X ^ 13 + C ((47271958685719 / 8639957931 : ℚ)) * X ^ 14 + C ((31315464815995 / 8639957931 : ℚ)) * X ^ 15 + C ((17710515774290 / 8639957931 : ℚ)) * X ^ 16 + C ((4288638157891 / 8639957931 : ℚ)) * X ^ 17 + C ((-1031927909392 / 2879985977 : ℚ)) * X ^ 18
def CV_111_4_pim : Polynomial ℚ := C ((-10830860766878 / 8639957931 : ℚ)) + C ((-21661721533756 / 8639957931 : ℚ)) * X + C ((-26718422460995 / 8639957931 : ℚ)) * X ^ 2 + C ((-1030872324532 / 261816907 : ℚ)) * X ^ 3 + C ((-33304720458596 / 8639957931 : ℚ)) * X ^ 4 + C ((-714854775155 / 261816907 : ℚ)) * X ^ 5 + C ((-10032684743216 / 8639957931 : ℚ)) * X ^ 6 + C ((8464817459411 / 8639957931 : ℚ)) * X ^ 7 + C ((18704847470927 / 8639957931 : ℚ)) * X ^ 8 + C ((5921499545565 / 2879985977 : ℚ)) * X ^ 9 + C ((4551234689181 / 2879985977 : ℚ)) * X ^ 10 + C ((6132933321358 / 2879985977 : ℚ)) * X ^ 11 + C ((7714631953535 / 2879985977 : ℚ)) * X ^ 12 + C ((24089802218692 / 8639957931 : ℚ)) * X ^ 13 + C ((10149939211007 / 2879985977 : ℚ)) * X ^ 14 + C ((32353150908955 / 8639957931 : ℚ)) * X ^ 15 + C ((27939453595906 / 8639957931 : ℚ)) * X ^ 16 + C ((6939772373939 / 2879985977 : ℚ)) * X ^ 17 + C ((7622630484622 / 8639957931 : ℚ)) * X ^ 18
theorem CV_111_4_pre_eq :
    CV_2_re_100 * Fplus_dW_re_011 - CV_2_im_100 * Fplus_dW_im_011 = CV_111_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_111_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_4_pim_eq :
    CV_2_re_100 * Fplus_dW_im_011 + CV_2_im_100 * Fplus_dW_re_011 = CV_111_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_111_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_4_mul :
    CV_2_c_100 * Fplus_dW_c_011 = ofLadj CV_111_4_pre CV_111_4_pim := by
  rw [CV_2_c_100_def, Fplus_dW_c_011_def, ofLadj_mul, CV_111_4_pre_eq, CV_111_4_pim_eq]

def CV_111_5_pre : Polynomial ℚ := C ((15841835025178 / 2879985977 : ℚ)) + C ((216182906131080 / 2879985977 : ℚ)) * X + C ((1319005209752378 / 8639957931 : ℚ)) * X ^ 2 + C ((722856723516482 / 2879985977 : ℚ)) * X ^ 3 + C ((3228624873944264 / 8639957931 : ℚ)) * X ^ 4 + C ((3836013430075862 / 8639957931 : ℚ)) * X ^ 5 + C ((4326559252973216 / 8639957931 : ℚ)) * X ^ 6 + C ((1531689306205103 / 2879985977 : ℚ)) * X ^ 7 + C ((4377601238714603 / 8639957931 : ℚ)) * X ^ 8 + C ((4294844339926958 / 8639957931 : ℚ)) * X ^ 9 + C ((4231644198137104 / 8639957931 : ℚ)) * X ^ 10 + C ((1386837327783878 / 2879985977 : ℚ)) * X ^ 11 + C ((3583095479743864 / 8639957931 : ℚ)) * X ^ 12 + C ((991946376724860 / 2879985977 : ℚ)) * X ^ 13 + C ((2209031068165157 / 8639957931 : ℚ)) * X ^ 14 + C ((408339483237419 / 2879985977 : ℚ)) * X ^ 15 + C ((220956773349954 / 2879985977 : ℚ)) * X ^ 16 + C ((57441499050836 / 2879985977 : ℚ)) * X ^ 17 + C ((-141424594958788 / 8639957931 : ℚ)) * X ^ 18
def CV_111_5_pim : Polynomial ℚ := C ((-436884095420434 / 8639957931 : ℚ)) + C ((-873768190840868 / 8639957931 : ℚ)) * X + C ((-1036463695576972 / 8639957931 : ℚ)) * X ^ 2 + C ((-111038023919854 / 785450721 : ℚ)) * X ^ 3 + C ((-27822984029594 / 261816907 : ℚ)) * X ^ 4 + C ((-320473683696170 / 8639957931 : ℚ)) * X ^ 5 + C ((159009881416204 / 8639957931 : ℚ)) * X ^ 6 + C ((863954081634943 / 8639957931 : ℚ)) * X ^ 7 + C ((1267857487942247 / 8639957931 : ℚ)) * X ^ 8 + C ((1255958102475968 / 8639957931 : ℚ)) * X ^ 9 + C ((1201232612436314 / 8639957931 : ℚ)) * X ^ 10 + C ((1557856673140562 / 8639957931 : ℚ)) * X ^ 11 + C ((1914480733844810 / 8639957931 : ℚ)) * X ^ 12 + C ((2022450748541260 / 8639957931 : ℚ)) * X ^ 13 + C ((2195505930616403 / 8639957931 : ℚ)) * X ^ 14 + C ((1926981969156341 / 8639957931 : ℚ)) * X ^ 15 + C ((466536433395628 / 2879985977 : ℚ)) * X ^ 16 + C ((334599885844446 / 2879985977 : ℚ)) * X ^ 17 + C ((369167577625574 / 8639957931 : ℚ)) * X ^ 18
theorem CV_111_5_pre_eq :
    CV_2_re_001 * Fplus_dW_re_110 - CV_2_im_001 * Fplus_dW_im_110 = CV_111_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_111_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_5_pim_eq :
    CV_2_re_001 * Fplus_dW_im_110 + CV_2_im_001 * Fplus_dW_re_110 = CV_111_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_111_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_5_mul :
    CV_2_c_001 * Fplus_dW_c_110 = ofLadj CV_111_5_pre CV_111_5_pim := by
  rw [CV_2_c_001_def, Fplus_dW_c_110_def, ofLadj_mul, CV_111_5_pre_eq, CV_111_5_pim_eq]

def CV_111_6_pre : Polynomial ℚ := C ((9476970950 / 785450721 : ℚ)) + C ((3162650146 / 261816907 : ℚ)) * X ^ 2 + C ((5366789911 / 785450721 : ℚ)) * X ^ 3 + C ((15405397445 / 785450721 : ℚ)) * X ^ 4 + C ((5451801335 / 261816907 : ℚ)) * X ^ 5 + C ((5451801335 / 261816907 : ℚ)) * X ^ 6 + C ((15405397445 / 785450721 : ℚ)) * X ^ 7 + C ((5366789911 / 785450721 : ℚ)) * X ^ 8 + C ((3162650146 / 261816907 : ℚ)) * X ^ 9
def CV_111_6_pim : Polynomial ℚ := C ((-33316982576 / 8639957931 : ℚ)) + C ((-66633965152 / 8639957931 : ℚ)) * X + C ((-60726040754 / 8639957931 : ℚ)) * X ^ 2 + C ((-142081800413 / 8639957931 : ℚ)) * X ^ 3 + C ((-21441145257 / 2879985977 : ℚ)) * X ^ 4 + C ((-107025117737 / 8639957931 : ℚ)) * X ^ 5 + C ((40391152585 / 8639957931 : ℚ)) * X ^ 6 + C ((-2310529381 / 8639957931 : ℚ)) * X ^ 7 + C ((75447835261 / 8639957931 : ℚ)) * X ^ 8 + C ((-5907924398 / 8639957931 : ℚ)) * X ^ 9
theorem CV_111_6_neg_re : -CV_3_re_111 = CV_111_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_111_def, CV_111_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_6_neg_im : -CV_3_im_111 = CV_111_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_111_def, CV_111_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_111_6_mul : -CV_3_c_111 = ofLadj CV_111_6_pre CV_111_6_pim := by
  rw [CV_3_c_111_def, ofLadj_neg, CV_111_6_neg_re, CV_111_6_neg_im]

theorem CV_111_7_mul : CV_3_c_101 = ofLadj CV_3_re_101 CV_3_im_101 := CV_3_c_101_def

@[expose] public def CV_coeff_111 : Ki := CV_0_c_100 * Fplus_dU_c_011 + CV_0_c_001 * Fplus_dU_c_110 + CV_1_c_100 * Fplus_dV_c_011 + CV_1_c_001 * Fplus_dV_c_110 + CV_2_c_100 * Fplus_dW_c_011 + CV_2_c_001 * Fplus_dW_c_110 + (-CV_3_c_111) + CV_3_c_101

theorem CV_coeff_111_sum :
    CV_coeff_111 = ofLadj (CV_111_0_pre + CV_111_1_pre + CV_111_2_pre + CV_111_3_pre + CV_111_4_pre + CV_111_5_pre + CV_111_6_pre + CV_3_re_101) (CV_111_0_pim + CV_111_1_pim + CV_111_2_pim + CV_111_3_pim + CV_111_4_pim + CV_111_5_pim + CV_111_6_pim + CV_3_im_101) := by
  simp only [CV_coeff_111, CV_111_0_mul, CV_111_1_mul, CV_111_2_mul, CV_111_3_mul, CV_111_4_mul, CV_111_5_mul, CV_111_6_mul, CV_111_7_mul]
  simp [ofLadj_add, add_assoc]

def CV_111_qre : Polynomial ℚ := C ((11852761143526 / 2879985977 : ℚ)) + C ((1698577951686958 / 8639957931 : ℚ)) * X + C ((559202808345488 / 2879985977 : ℚ)) * X ^ 2 + C ((2306993017794826 / 8639957931 : ℚ)) * X ^ 3 + C ((3423736425927787 / 8639957931 : ℚ)) * X ^ 4 + C ((783614853034029 / 2879985977 : ℚ)) * X ^ 5 + C ((2175523342101511 / 8639957931 : ℚ)) * X ^ 6 + C ((1420583923347488 / 8639957931 : ℚ)) * X ^ 7 + C ((-323542937508181 / 8639957931 : ℚ)) * X ^ 8
def CV_111_qim : Polynomial ℚ := C ((-1478692828255132 / 8639957931 : ℚ)) + C ((-1478692828255132 / 8639957931 : ℚ)) * X + C ((-871858452925370 / 8639957931 : ℚ)) * X ^ 2 + C ((-119027851495996 / 785450721 : ℚ)) * X ^ 3 + C ((41966833426631 / 2879985977 : ℚ)) * X ^ 4 + C ((108562028129371 / 785450721 : ℚ)) * X ^ 5 + C ((1130420317256359 / 8639957931 : ℚ)) * X ^ 6 + C ((758498693354526 / 2879985977 : ℚ)) * X ^ 7 + C ((42647341720773 / 261816907 : ℚ)) * X ^ 8
theorem CV_coeff_111_poly_re :
    CV_111_0_pre + CV_111_1_pre + CV_111_2_pre + CV_111_3_pre + CV_111_4_pre + CV_111_5_pre + CV_111_6_pre + CV_3_re_101 = (0 : Polynomial ℚ) + Phi11 * CV_111_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_111_0_pre, CV_111_1_pre, CV_111_2_pre, CV_111_3_pre, CV_111_4_pre, CV_111_5_pre, CV_111_6_pre, CV_3_re_101_def, CV_111_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_111_poly_im :
    CV_111_0_pim + CV_111_1_pim + CV_111_2_pim + CV_111_3_pim + CV_111_4_pim + CV_111_5_pim + CV_111_6_pim + CV_3_im_101 = (0 : Polynomial ℚ) + Phi11 * CV_111_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_111_0_pim, CV_111_1_pim, CV_111_2_pim, CV_111_3_pim, CV_111_4_pim, CV_111_5_pim, CV_111_6_pim, CV_3_im_101_def, CV_111_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_111_eq :
    CV_coeff_111 = (0 : Ki) := by
  rw [CV_coeff_111_sum, CV_coeff_111_poly_re,
    CV_coeff_111_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
