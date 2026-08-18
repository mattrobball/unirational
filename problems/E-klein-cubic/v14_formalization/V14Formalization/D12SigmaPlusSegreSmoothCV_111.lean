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

def CV_111_0_pre : Polynomial ℚ := interpQ 8639957931 [344805380590, 9574596444760, 18811154893746, 31083499809548, 46910699934184, 55472153502184, 62823850998562, 66314300008593, 63197355059316, 61948376374388, 61079829698730, 60385417000952, 51505233253970, 43137221480642, 32113855249768, 17397745384797, 9493576006684, 2141878510306, -2005854689612]
def CV_111_0_pim : Polynomial ℚ := interpQ 8639957931 [-6598442754606, -13196885509212, -15205493287424, -18748512388942, -14118547875668, -5531317010672, 1425380453496, 11680991918683, 17170524819488, 16970004349672, 16151141311180, 21604609256558, 27058077201936, 28247821941656, 31590320573358, 27485036871667, 19930171890230, 14188097670850, 4964852089222]
theorem CV_111_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_011 - CV_0_im_100 * Fplus_dU_im_011 = CV_111_0_pre := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_111_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_011 + CV_0_im_100 * Fplus_dU_re_011 = CV_111_0_pim := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_111_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_0_mul :
    CV_0_c_100 * Fplus_dU_c_011 = ofLadj CV_111_0_pre CV_111_0_pim := by
  rw [CV_0_c_100_def, Fplus_dU_c_011_def, ofLadj_mul, CV_111_0_pre_eq, CV_111_0_pim_eq]

def CV_111_1_pre : Polynomial ℚ := interpQ 8639957931 [-2505252747234, 396838302772160, 793955280280099, 1293751004619975, 2186853921560672, 2799449234664180, 3376090760604277, 3627130523690358, 3376189079967781, 3196927650876704, 3059569883604161, 3011377542240402, 2662731580832001, 2402972370596605, 2082438075347806, 1354570665502759, 839975329021360, 263333803081263, -85705936626927]
def CV_111_1_pim : Polynomial ℚ := interpQ 8639957931 [-376294894480004, -752589788960008, -972884803035333, -1334618668609807, -1342025143296720, -985894679799876, -590397139698843, 167177521974240, 578945005494909, 552911803430056, 434214762313381, 636486058036480, 838757353759579, 940355326718229, 1276055990227850, 1359004331118091, 1155250169761514, 941423976850157, 336225617317341]
theorem CV_111_1_pre_eq :
    CV_0_re_001 * Fplus_dU_re_110 - CV_0_im_001 * Fplus_dU_im_110 = CV_111_1_pre := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_111_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_1_pim_eq :
    CV_0_re_001 * Fplus_dU_im_110 + CV_0_im_001 * Fplus_dU_re_110 = CV_111_1_pim := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_111_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_1_mul :
    CV_0_c_001 * Fplus_dU_c_110 = ofLadj CV_111_1_pre CV_111_1_pim := by
  rw [CV_0_c_001_def, Fplus_dU_c_110_def, ofLadj_mul, CV_111_1_pre_eq, CV_111_1_pim_eq]

def CV_111_2_pre : Polynomial ℚ := interpQ 8639957931 [-7155705805780, -109968920040000, -217410548479126, -356821900283234, -532251322446382, -632849553102225, -716865208165766, -766731525101282, -730575050288619, -722271309182845, -716035684862097, -706433366512840, -606066764822097, -504860760703719, -373753150005385, -205866341412024, -109823618206438, -25807963142897, 28613861242876]
def CV_111_2_pim : Polynomial ℚ := interpQ 8639957931 [75140707217620, 150281414435240, 175563027886324, 211562730724944, 161709104397812, 63343696003993, -16706519911316, -138057853141822, -208400675994461, -207148402549601, -201747836680653, -268855907128608, -335963977576563, -355845025158699, -390592454552459, -344274574647090, -252820198248956, -181247377665697, -66807076430876]
theorem CV_111_2_pre_eq :
    CV_1_re_100 * Fplus_dV_re_011 - CV_1_im_100 * Fplus_dV_im_011 = CV_111_2_pre := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_111_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_2_pim_eq :
    CV_1_re_100 * Fplus_dV_im_011 + CV_1_im_100 * Fplus_dV_re_011 = CV_111_2_pim := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_111_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_2_mul :
    CV_1_c_100 * Fplus_dV_c_011 = ofLadj CV_111_2_pre CV_111_2_pim := by
  rw [CV_1_c_100_def, Fplus_dV_c_011_def, ofLadj_mul, CV_111_2_pre_eq, CV_111_2_pim_eq]

def CV_111_3_pre : Polynomial ℚ := interpQ 8639957931 [-1139337765078, 779062767906520, 1473287453496336, 2539425604980455, 4144679642101203, 5348556770901266, 6520134844116090, 7465577173887878, 7589469110508082, 7854208467423816, 8056804339850221, 8132995451975450, 7277741571943701, 6380921013927480, 5050043505527627, 3200972903039121, 1852338205295060, 680760132080236, -119924628747554]
def CV_111_3_pim : Polynomial ℚ := interpQ 8639957931 [-719822479115162, -1439644958230324, -1944437585107538, -2731671257427795, -2858621304744279, -2541121695126608, -2229740519556414, -1327096193500442, -682298374306984, -643936610408320, -468693375530935, 508013602902896, 1484720581336727, 2164756443091326, 2990351879310247, 3005911070120563, 2463369776919868, 1883874685338622, 756188675699626]
theorem CV_111_3_pre_eq :
    CV_1_re_001 * Fplus_dV_re_110 - CV_1_im_001 * Fplus_dV_im_110 = CV_111_3_pre := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_111_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_3_pim_eq :
    CV_1_re_001 * Fplus_dV_im_110 + CV_1_im_001 * Fplus_dV_re_110 = CV_111_3_pim := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_111_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_3_mul :
    CV_1_c_001 * Fplus_dV_c_110 = ofLadj CV_111_3_pre CV_111_3_pim := by
  rw [CV_1_c_001_def, Fplus_dV_c_110_def, ofLadj_mul, CV_111_3_pre_eq, CV_111_3_pim_eq]

def CV_111_4_pre : Polynomial ℚ := interpQ 8639957931 [-480172093874, 10080769640856, 21450712182239, 36558797408460, 58284290779700, 75380798301825, 88802675918224, 92695539323871, 83830756094179, 77580067472169, 72820424491399, 71487679433342, 62739654850543, 56129355289930, 47271958685719, 31315464815995, 17710515774290, 4288638157891, -3095783728176]
def CV_111_4_pim : Polynomial ℚ := interpQ 8639957931 [-10830860766878, -21661721533756, -26718422460995, -34018786709556, -33304720458596, -23590207580115, -10032684743216, 8464817459411, 18704847470927, 17764498636695, 13653704067543, 18398799964074, 23143895860605, 24089802218692, 30449817633021, 32353150908955, 27939453595906, 20819317121817, 7622630484622]
theorem CV_111_4_pre_eq :
    CV_2_re_100 * Fplus_dW_re_011 - CV_2_im_100 * Fplus_dW_im_011 = CV_111_4_pre := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_111_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_4_pim_eq :
    CV_2_re_100 * Fplus_dW_im_011 + CV_2_im_100 * Fplus_dW_re_011 = CV_111_4_pim := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_111_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_4_mul :
    CV_2_c_100 * Fplus_dW_c_011 = ofLadj CV_111_4_pre CV_111_4_pim := by
  rw [CV_2_c_100_def, Fplus_dW_c_011_def, ofLadj_mul, CV_111_4_pre_eq, CV_111_4_pim_eq]

def CV_111_5_pre : Polynomial ℚ := interpQ 8639957931 [47525505075534, 648548718393240, 1319005209752378, 2168570170549446, 3228624873944264, 3836013430075862, 4326559252973216, 4595067918615309, 4377601238714603, 4294844339926958, 4231644198137104, 4160511983351634, 3583095479743864, 2975839130174580, 2209031068165157, 1225018449712257, 662870320049862, 172324497152508, -141424594958788]
def CV_111_5_pim : Polynomial ℚ := interpQ 8639957931 [-436884095420434, -873768190840868, -1036463695576972, -1221418263118394, -918158472976602, -320473683696170, 159009881416204, 863954081634943, 1267857487942247, 1255958102475968, 1201232612436314, 1557856673140562, 1914480733844810, 2022450748541260, 2195505930616403, 1926981969156341, 1399609300186884, 1003799657533338, 369167577625574]
theorem CV_111_5_pre_eq :
    CV_2_re_001 * Fplus_dW_re_110 - CV_2_im_001 * Fplus_dW_im_110 = CV_111_5_pre := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_111_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_5_pim_eq :
    CV_2_re_001 * Fplus_dW_im_110 + CV_2_im_001 * Fplus_dW_re_110 = CV_111_5_pim := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_111_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_5_mul :
    CV_2_c_001 * Fplus_dW_c_110 = ofLadj CV_111_5_pre CV_111_5_pim := by
  rw [CV_2_c_001_def, Fplus_dW_c_110_def, ofLadj_mul, CV_111_5_pre_eq, CV_111_5_pim_eq]

def CV_111_6_pre : Polynomial ℚ := interpQ 8639957931 [104246680450, 0, 104367454818, 59034689021, 169459371895, 179909444055, 179909444055, 169459371895, 59034689021, 104367454818]
def CV_111_6_pim : Polynomial ℚ := interpQ 8639957931 [-33316982576, -66633965152, -60726040754, -142081800413, -64323435771, -107025117737, 40391152585, -2310529381, 75447835261, -5907924398]
theorem CV_111_6_neg_re : -CV_3_re_111 = CV_111_6_pre := by
  simp only [CV_3_re_111_def, CV_111_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_6_neg_im : -CV_3_im_111 = CV_111_6_pim := by
  simp only [CV_3_im_111_def, CV_111_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_111_6_mul : -CV_3_c_111 = ofLadj CV_111_6_pre CV_111_6_pim := by
  rw [CV_3_c_111_def, ofLadj_neg, CV_111_6_neg_re, CV_111_6_neg_im]

theorem CV_111_7_mul : CV_3_c_101 = ofLadj CV_3_re_101 CV_3_im_101 := CV_3_c_101_def

@[expose] public def CV_coeff_111 : Ki := CV_0_c_100 * Fplus_dU_c_011 + CV_0_c_001 * Fplus_dU_c_110 + CV_1_c_100 * Fplus_dV_c_011 + CV_1_c_001 * Fplus_dV_c_110 + CV_2_c_100 * Fplus_dW_c_011 + CV_2_c_001 * Fplus_dW_c_110 + (-CV_3_c_111) + CV_3_c_101

theorem CV_coeff_111_sum :
    CV_coeff_111 = ofLadj (CV_111_0_pre + CV_111_1_pre + CV_111_2_pre + CV_111_3_pre + CV_111_4_pre + CV_111_5_pre + CV_111_6_pre + CV_3_re_101) (CV_111_0_pim + CV_111_1_pim + CV_111_2_pim + CV_111_3_pim + CV_111_4_pim + CV_111_5_pim + CV_111_6_pim + CV_3_im_101) := by
  simp only [CV_coeff_111, CV_111_0_mul, CV_111_1_mul, CV_111_2_mul, CV_111_3_mul, CV_111_4_mul, CV_111_5_mul, CV_111_6_mul, CV_111_7_mul]
  simp [ofLadj_add, add_assoc]

def CV_111_qre : Polynomial ℚ := interpQ 8639957931 [35558283430578, 1698577951686958, 1677608425036464, 2306993017794826, 3423736425927787, 2350844559102087, 2175523342101511, 1420583923347488, -323542937508181]
def CV_111_qim : Polynomial ℚ := interpQ 8639957931 [-1478692828255132, -1478692828255132, -871858452925370, -1309306366455956, 125900500279893, 1194182309423081, 1130420317256359, 2275496080063578, 1407362276785509]
theorem CV_coeff_111_poly_re :
    CV_111_0_pre + CV_111_1_pre + CV_111_2_pre + CV_111_3_pre + CV_111_4_pre + CV_111_5_pre + CV_111_6_pre + CV_3_re_101 = (0 : Polynomial ℚ) + Phi11 * CV_111_qre := by
  rw [phi11_interpQ]
  simp only [CV_111_0_pre, CV_111_1_pre, CV_111_2_pre, CV_111_3_pre, CV_111_4_pre, CV_111_5_pre, CV_111_6_pre, CV_3_re_101_def, CV_111_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_111_poly_im :
    CV_111_0_pim + CV_111_1_pim + CV_111_2_pim + CV_111_3_pim + CV_111_4_pim + CV_111_5_pim + CV_111_6_pim + CV_3_im_101 = (0 : Polynomial ℚ) + Phi11 * CV_111_qim := by
  rw [phi11_interpQ]
  simp only [CV_111_0_pim, CV_111_1_pim, CV_111_2_pim, CV_111_3_pim, CV_111_4_pim, CV_111_5_pim, CV_111_6_pim, CV_3_im_101_def, CV_111_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_111_eq :
    CV_coeff_111 = (0 : Ki) := by
  rw [CV_coeff_111_sum, CV_coeff_111_poly_re,
    CV_coeff_111_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
