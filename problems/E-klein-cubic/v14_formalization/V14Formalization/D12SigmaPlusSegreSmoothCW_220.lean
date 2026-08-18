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

def CW_220_0_pre : Polynomial ℚ := interpQ 8639957931 [-513950307140, 3160194923352, 5323015922163, 9572648260351, 16867428636151, 20622570546450, 26200066747426, 27553968962992, 25242906419443, 24223668348762, 22592208454261, 23245381869558, 19432013530909, 18900652426599, 15670258159092, 9925413408204, 6739666270810, 1162170069834, -761126918637]
def CW_220_0_pim : Polynomial ℚ := interpQ 8639957931 [-3137741711641, -6275483423282, -7545434468302, -11518418366573, -10623660836707, -8481814136722, -5781058002301, 1089455564377, 3225802021915, 3414639708408, 2247129015752, 4065708169606, 5884287323460, 5986727675824, 10148549260588, 9436524704889, 9018863867199, 7099941187754, 1953613483371]
theorem CW_220_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_110 - CW_0_im_110 * Fplus_dU_im_110 = CW_220_0_pre := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_220_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_110 + CW_0_im_110 * Fplus_dU_re_110 = CW_220_0_pim := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_220_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_0_mul :
    CW_0_c_110 * Fplus_dU_c_110 = ofLadj CW_220_0_pre CW_220_0_pim := by
  rw [CW_0_c_110_def, Fplus_dU_c_110_def, ofLadj_mul, CW_220_0_pre_eq, CW_220_0_pim_eq]

def CW_220_1_pre : Polynomial ℚ := interpQ 8639957931 [1826505216765, 0, 1915817504166, 506356931559, -1717884822537, -2832705661893, -5866595529507, -7092871954017, -7280863553892, -7378380816138, -7901556757884, -9461471601903, -7901556757884, -9294198320304, -7787220485451, -5148570071439, -3950875059945, -916985192331, 226417060041]
def CW_220_1_pim : Polynomial ℚ := interpQ 8639957931 [1660344326037, 3320688652074, 4208602475346, 8104755820392, 8255585387718, 10183493027091, 9826741897491, 8521817860029, 8161577233506, 8307926627229, 8026130626809, 6087929195469, 4149727764129, 2980017940437, -769786010886, -1069187502948, -2419095519312, -2094592362258, -211668701787]
theorem CW_220_1_pre_eq :
    CW_0_re_020 * Fplus_dU_re_200 - CW_0_im_020 * Fplus_dU_im_200 = CW_220_1_pre := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_220_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_1_pim_eq :
    CW_0_re_020 * Fplus_dU_im_200 + CW_0_im_020 * Fplus_dU_re_200 = CW_220_1_pim := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_220_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_1_mul :
    CW_0_c_020 * Fplus_dU_c_200 = ofLadj CW_220_1_pre CW_220_1_pim := by
  rw [CW_0_c_020_def, Fplus_dU_c_200_def, ofLadj_mul, CW_220_1_pre_eq, CW_220_1_pim_eq]

def CW_220_2_pre : Polynomial ℚ := interpQ 8639957931 [-830891698005, 3819108598110, 5990931830626, 11425929606353, 19302154481075, 23794453988119, 30560368142206, 34158826077863, 34853409366299, 35679972419932, 37273125079592, 37881649517178, 33454016481482, 29689040589306, 23427479759946, 14101678216392, 9148067593233, 2382153439146, -754993380396]
def CW_220_2_pim : Polynomial ℚ := interpQ 8639957931 [-3771439028256, -7542878056512, -9195167656914, -14557088329657, -13681141167970, -13445083358872, -11803968318461, -7407257614182, -4587142557545, -4843332482385, -3712709342227, 1220233643978, 6153176630183, 8936089370743, 14041820118646, 13056987990714, 11164892003089, 8981748905688, 2929000022882]
theorem CW_220_2_pre_eq :
    CW_1_re_110 * Fplus_dV_re_110 - CW_1_im_110 * Fplus_dV_im_110 = CW_220_2_pre := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_220_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_2_pim_eq :
    CW_1_re_110 * Fplus_dV_im_110 + CW_1_im_110 * Fplus_dV_re_110 = CW_220_2_pim := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_220_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_2_mul :
    CW_1_c_110 * Fplus_dV_c_110 = ofLadj CW_220_2_pre CW_220_2_pim := by
  rw [CW_1_c_110_def, Fplus_dV_c_110_def, ofLadj_mul, CW_220_2_pre_eq, CW_220_2_pim_eq]

def CW_220_3_pre : Polynomial ℚ := interpQ 8639957931 [370433125919, -477290527184, -349625349092, -1212353614243, -2456258546333, -2453650230802, -3953253628402, -3847782677397, -3221158620727, -3252773301376, -2743907264641, -3440376450554, -2266616737457, -2903147952284, -2008805006484, -1170523893715, -1161071568085, 338531829515, 221000237349]
def CW_220_3_pim : Polynomial ℚ := interpQ 8639957931 [557559427776, 1115118855552, 1111378408216, 2283550672326, 1577654791714, 1627399148158, 1434135590577, -215373204439, -18722580555, -231104927096, 78577281678, -313628972160, -705835225998, -392412569888, -1776967180539, -867757336371, -1470143038215, -1103530789288, -6663339672]
theorem CW_220_3_pre_eq :
    CW_1_re_020 * Fplus_dV_re_200 - CW_1_im_020 * Fplus_dV_im_200 = CW_220_3_pre := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_220_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_3_pim_eq :
    CW_1_re_020 * Fplus_dV_im_200 + CW_1_im_020 * Fplus_dV_re_200 = CW_220_3_pim := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_220_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_3_mul :
    CW_1_c_020 * Fplus_dV_c_200 = ofLadj CW_220_3_pre CW_220_3_pim := by
  rw [CW_1_c_020_def, Fplus_dV_c_200_def, ofLadj_mul, CW_220_3_pre_eq, CW_220_3_pim_eq]

def CW_220_4_pre : Polynomial ℚ := interpQ 8639957931 [-1776681427452, -849633366480, -3693843302726, -4647911362842, -5472203291093, -9012307012416, -7544159740687, -9433349649499, -9233725712345, -9142635655213, -9002743460456, -7318858842246, -8153110093976, -5448792352487, -4585814349503, -3925764702640, -417294101263, -1885441372992, 35381655766]
def CW_220_4_pim : Polynomial ℚ := interpQ 8639957931 [-142000432542, -284000865084, 1269818763484, -1446240683480, 602790032457, -2164058222236, -3471137717799, -3736204087423, -5453939925053, -5468512577060, -5365361545554, -5123540248084, -4881718950614, -6332387547676, -3630900752719, -5650337996776, -3080689359465, -1815196061752, -1747329309510]
theorem CW_220_4_pre_eq :
    CW_2_re_110 * Fplus_dW_re_110 - CW_2_im_110 * Fplus_dW_im_110 = CW_220_4_pre := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_220_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_4_pim_eq :
    CW_2_re_110 * Fplus_dW_im_110 + CW_2_im_110 * Fplus_dW_re_110 = CW_220_4_pim := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_220_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_4_mul :
    CW_2_c_110 * Fplus_dW_c_110 = ofLadj CW_220_4_pre CW_220_4_pim := by
  rw [CW_2_c_110_def, Fplus_dW_c_110_def, ofLadj_mul, CW_220_4_pre_eq, CW_220_4_pim_eq]

def CW_220_5_pre : Polynomial ℚ := interpQ 8639957931 [-1749167551060, -58201967104, -2864058148630, -5011989619192, -3700133593028, -8062868149126, -5408527025338, -8021706528865, -6432540082598, -6201823179787, -6289098234692, -4304544034880, -6230896267588, -3337765031157, -1420550463406, -2677308004857, 1514041201098, -1140299922690, 1644264930980]
def CW_220_5_pim : Polynomial ℚ := interpQ 8639957931 [-1134585635192, -2269171270384, 521962235966, -4687389560889, -2962410875846, -5958267163825, -8130310628228, -8639070318995, -11468940565933, -11320982722761, -11415132410123, -10110205108656, -8805277807189, -11690561000901, -6333251360874, -8216413564539, -5116863620555, -3284140075088, -2671686728316]
theorem CW_220_5_pre_eq :
    CW_2_re_020 * Fplus_dW_re_200 - CW_2_im_020 * Fplus_dW_im_200 = CW_220_5_pre := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_220_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_5_pim_eq :
    CW_2_re_020 * Fplus_dW_im_200 + CW_2_im_020 * Fplus_dW_re_200 = CW_220_5_pim := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_220_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_220_5_mul :
    CW_2_c_020 * Fplus_dW_c_200 = ofLadj CW_220_5_pre CW_220_5_pim := by
  rw [CW_2_c_020_def, Fplus_dW_c_200_def, ofLadj_mul, CW_220_5_pre_eq, CW_220_5_pim_eq]

@[expose] public def CW_coeff_220 : Ki := CW_0_c_110 * Fplus_dU_c_110 + CW_0_c_020 * Fplus_dU_c_200 + CW_1_c_110 * Fplus_dV_c_110 + CW_1_c_020 * Fplus_dV_c_200 + CW_2_c_110 * Fplus_dW_c_110 + CW_2_c_020 * Fplus_dW_c_200

theorem CW_coeff_220_sum :
    CW_coeff_220 = ofLadj (CW_220_0_pre + CW_220_1_pre + CW_220_2_pre + CW_220_3_pre + CW_220_4_pre + CW_220_5_pre) (CW_220_0_pim + CW_220_1_pim + CW_220_2_pim + CW_220_3_pim + CW_220_4_pim + CW_220_5_pim) := by
  simp only [CW_coeff_220, CW_220_0_mul, CW_220_1_mul, CW_220_2_mul, CW_220_3_mul, CW_220_4_mul, CW_220_5_mul]
  simpa [add_assoc] using ofLadj_add6 CW_220_0_pre CW_220_0_pim CW_220_1_pre CW_220_1_pim CW_220_2_pre CW_220_2_pim CW_220_3_pre CW_220_3_pim CW_220_4_pre CW_220_4_pim CW_220_5_pre CW_220_5_pim

def CW_220_qre : Polynomial ℚ := interpQ 8639957931 [-2673752640973, 8267930301667, 728060795813, 4310441745479, 12190422662249, -767609383903, 11932405485366, -670814734621, 610943585103]
def CW_220_qim : Polynomial ℚ := interpQ 8639957931 [-5967863053818, -5967863053818, 2306885865432, -12191990205677, 4989647779247, -1407148037772, 312733527685, 7538965378088, 245265426968]
theorem CW_coeff_220_poly_re :
    CW_220_0_pre + CW_220_1_pre + CW_220_2_pre + CW_220_3_pre + CW_220_4_pre + CW_220_5_pre = (0 : Polynomial ℚ) + Phi11 * CW_220_qre := by
  rw [phi11_interpQ]
  simp only [CW_220_0_pre, CW_220_1_pre, CW_220_2_pre, CW_220_3_pre, CW_220_4_pre, CW_220_5_pre, CW_220_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_220_poly_im :
    CW_220_0_pim + CW_220_1_pim + CW_220_2_pim + CW_220_3_pim + CW_220_4_pim + CW_220_5_pim = (0 : Polynomial ℚ) + Phi11 * CW_220_qim := by
  rw [phi11_interpQ]
  simp only [CW_220_0_pim, CW_220_1_pim, CW_220_2_pim, CW_220_3_pim, CW_220_4_pim, CW_220_5_pim, CW_220_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_220_eq :
    CW_coeff_220 = (0 : Ki) := by
  rw [CW_coeff_220_sum, CW_coeff_220_poly_re,
    CW_coeff_220_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
