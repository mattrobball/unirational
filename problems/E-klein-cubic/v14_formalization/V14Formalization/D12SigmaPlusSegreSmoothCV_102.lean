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

def CV_102_0_pre : Polynomial ℚ := interpQ 17279915862 [277843159766, 13404435022664, 25738704557368, 42037552476704, 64891790526216, 78007344912527, 90715437733928, 98363864375444, 96757269781776, 98062478051241, 99033101159360, 99145685470388, 85628666136696, 72323773493873, 54719717305072, 30650357867742, 16767627567010, 4059534745609, -2821715981486]
def CV_102_0_pim : Polynomial ℚ := interpQ 17279915862 [-9812295643134, -19624591286268, -23200900616330, -30216102257556, -26103478092348, -16251231525569, -8641656197068, 5281047584502, 12615519630430, 12871508626387, 13697737553036, 24788932985668, 35880128418300, 40282666675011, 47553857312194, 42852377518540, 31954262868872, 22891899538833, 7923327674374]
theorem CV_102_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_002 - CV_0_im_100 * Fplus_dU_im_002 = CV_102_0_pre := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_102_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_002 + CV_0_im_100 * Fplus_dU_re_002 = CV_102_0_pim := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_102_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_0_mul :
    CV_0_c_100 * Fplus_dU_c_002 = ofLadj CV_102_0_pre CV_102_0_pim := by
  rw [CV_0_c_100_def, Fplus_dU_c_002_def, ofLadj_mul, CV_102_0_pre_eq, CV_102_0_pim_eq]

def CV_102_1_pre : Polynomial ℚ := interpQ 17279915862 [-444940050891952, -3174706422177280, -5985790189526128, -9414211961441640, -13401881358647880, -15361070017836342, -16818365029909898, -17493167669139208, -16206068529391422, -15959762628578006, -15773010586318368, -15257199639584040, -12598304164141088, -9973972439051878, -6791856567949782, -3029421745922528, -1204670190032162, 252624822041394, 1061864564568800]
def CV_102_1_pim : Polynomial ℚ := interpQ 17279915862 [1423005944751392, 2846011889502784, 2707684542615952, 2698017875451340, 731677910098600, -2312762469685338, -4645916803391734, -7617511118656324, -9263323288782754, -9228705205344606, -9065802849399836, -10250786400329920, -11435769951260004, -11134540248428402, -11090255497825642, -9226168989895068, -6391408881888070, -4305472756191914, -1543558712704264]
theorem CV_102_1_pre_eq :
    CV_0_re_001 * Fplus_dU_re_101 - CV_0_im_001 * Fplus_dU_im_101 = CV_102_1_pre := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_102_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_1_pim_eq :
    CV_0_re_001 * Fplus_dU_im_101 + CV_0_im_001 * Fplus_dU_re_101 = CV_102_1_pim := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CV_102_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_1_mul :
    CV_0_c_001 * Fplus_dU_c_101 = ofLadj CV_102_1_pre CV_102_1_pim := by
  rw [CV_0_c_001_def, Fplus_dU_c_101_def, ofLadj_mul, CV_102_1_pre_eq, CV_102_1_pim_eq]

def CV_102_2_pre : Polynomial ℚ := interpQ 17279915862 [-428801544320, 7854922860000, 16686849110726, 28584606633259, 45513274620103, 58829928114296, 69375303296501, 72445246385800, 65444513854574, 60508243423014, 56825342979938, 55851220379890, 48970420119938, 43821394312288, 36859907221315, 24452285591841, 13839660261443, 3294285079238, -2479686173856]
def CV_102_2_pim : Polynomial ℚ := interpQ 17279915862 [-8453055924830, -16906111849660, -20892442874486, -26588264960651, -25986189443615, -18407438679144, -7879244577745, 6718330893100, 14715657643284, 13963278945714, 10707353840154, 14434933058472, 18162512276790, 18892918196056, 23836361584651, 25297538034767, 21890618675745, 16359818848428, 5934074783032]
theorem CV_102_2_pre_eq :
    CV_1_re_100 * Fplus_dV_re_002 - CV_1_im_100 * Fplus_dV_im_002 = CV_102_2_pre := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_102_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_2_pim_eq :
    CV_1_re_100 * Fplus_dV_im_002 + CV_1_im_100 * Fplus_dV_re_002 = CV_102_2_pim := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_102_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_2_mul :
    CV_1_c_100 * Fplus_dV_c_002 = ofLadj CV_102_2_pre CV_102_2_pim := by
  rw [CV_1_c_100_def, Fplus_dV_c_002_def, ofLadj_mul, CV_102_2_pre_eq, CV_102_2_pim_eq]

def CV_102_3_pre : Polynomial ℚ := interpQ 17279915862 [225919154518168, 3116251071626080, 6336437617590620, 10418988675682972, 15513423032151636, 18435550739113868, 20788370707139124, 22080635446512816, 21033614944616966, 20635055481338376, 20332212191468562, 19992137851700240, 17215961119842482, 14298617863747756, 10614626268933994, 5885320291983040, 3180797316915768, 827977348890512, -681892122378140]
def CV_102_3_pim : Polynomial ℚ := interpQ 17279915862 [-2100227148554128, -4200454297108256, -4982603470901188, -5870442539195872, -4418203633353560, -1539531410597896, 761433249656404, 4151565383256856, 6090987882239978, 6034360040719772, 5770739625850326, 7485493786957224, 9200247948064122, 9718776706987608, 10549987933762086, 9263910616467708, 6724283723674488, 4824347714073196, 1773260910435188]
theorem CV_102_3_pre_eq :
    CV_1_re_001 * Fplus_dV_re_101 - CV_1_im_001 * Fplus_dV_im_101 = CV_102_3_pre := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_102_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_3_pim_eq :
    CV_1_re_001 * Fplus_dV_im_101 + CV_1_im_001 * Fplus_dV_re_101 = CV_102_3_pim := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CV_102_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_3_mul :
    CV_1_c_001 * Fplus_dV_c_101 = ofLadj CV_102_3_pre CV_102_3_pim := by
  rw [CV_1_c_001_def, Fplus_dV_c_101_def, ofLadj_mul, CV_102_3_pre_eq, CV_102_3_pim_eq]

def CV_102_4_pre : Polynomial ℚ := interpQ 17279915862 [-2250273378066, 0, 5931632317707, 13678792111020, 20772692958156, 25017968712438, 25017968712438, 20772692958156, 13678792111020, 5931632317707]
def CV_102_4_pim : Polynomial ℚ := interpQ 17279915862 [-7560577230642, -15121154461284, -20194148962029, -21323745991440, -18013661784066, -11512919946330, -3608234514954, 2892507322782, 6202591530156, 5072994500745]
theorem CV_102_4_pre_eq :
    CV_2_re_100 * Fplus_dW_re_002 - CV_2_im_100 * Fplus_dW_im_002 = CV_102_4_pre := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_102_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_4_pim_eq :
    CV_2_re_100 * Fplus_dW_im_002 + CV_2_im_100 * Fplus_dW_re_002 = CV_102_4_pim := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_102_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_4_mul :
    CV_2_c_100 * Fplus_dW_c_002 = ofLadj CV_102_4_pre CV_102_4_pim := by
  rw [CV_2_c_100_def, Fplus_dW_c_002_def, ofLadj_mul, CV_102_4_pre_eq, CV_102_4_pim_eq]

def CV_102_5_pre : Polynomial ℚ := interpQ 17279915862 [110149079306940, 1815936411501072, 3623932885372008, 5886979523356904, 8945570089081756, 10811369211193790, 12519137806343054, 13653244361607316, 13423411060192420, 13603826300150950, 13741315219076806, 13682594034008896, 11925378807575734, 9979893414778942, 7536431536835516, 4312290627014476, 2348050562250150, 640281967100886, -395383645511084]
def CV_102_5_pim : Polynomial ℚ := interpQ 17279915862 [-1301101313384404, -2602202626768808, -3171105047049372, -3963072738134892, -3439727410609032, -2071744405981462, -1011292309381950, 900107286548440, 2001582904786028, 2027590830098026, 2146822841197622, 3622653145825280, 5098483450452938, 5786617881833098, 6604593498230616, 6005441299247052, 4484367303757558, 3241773076487606, 1177282489695292]
theorem CV_102_5_pre_eq :
    CV_2_re_001 * Fplus_dW_re_101 - CV_2_im_001 * Fplus_dW_im_101 = CV_102_5_pre := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_102_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_5_pim_eq :
    CV_2_re_001 * Fplus_dW_im_101 + CV_2_im_001 * Fplus_dW_re_101 = CV_102_5_pim := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CV_102_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_5_mul :
    CV_2_c_001 * Fplus_dW_c_101 = ofLadj CV_102_5_pre CV_102_5_pim := by
  rw [CV_2_c_001_def, Fplus_dW_c_101_def, ofLadj_mul, CV_102_5_pre_eq, CV_102_5_pim_eq]

def CV_102_6_pre : Polynomial ℚ := interpQ 17279915862 [-4880834779612, 0, 12753761663016, 29537217200964, 44793931141740, 53885117193512, 53885117193512, 44793931141740, 29537217200964, 12753761663016]
def CV_102_6_pim : Polynomial ℚ := interpQ 17279915862 [-16271243469676, -32542486939352, -43553748434616, -45925928933532, -38811669147676, -24712441631552, -7830045307800, 6269182208324, 13383441994180, 11011261495264]
theorem CV_102_6_neg_re : -CV_3_re_102 = CV_102_6_pre := by
  simp only [CV_3_re_102_def, CV_102_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_6_neg_im : -CV_3_im_102 = CV_102_6_pim := by
  simp only [CV_3_im_102_def, CV_102_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_102_6_mul : -CV_3_c_102 = ofLadj CV_102_6_pre CV_102_6_pim := by
  rw [CV_3_c_102_def, ofLadj_neg, CV_102_6_neg_re, CV_102_6_neg_im]

@[expose] public def CV_coeff_102 : Ki := CV_0_c_100 * Fplus_dU_c_002 + CV_0_c_001 * Fplus_dU_c_101 + CV_1_c_100 * Fplus_dV_c_002 + CV_1_c_001 * Fplus_dV_c_101 + CV_2_c_100 * Fplus_dW_c_002 + CV_2_c_001 * Fplus_dW_c_101 + (-CV_3_c_102)

theorem CV_coeff_102_sum :
    CV_coeff_102 = ofLadj (CV_102_0_pre + CV_102_1_pre + CV_102_2_pre + CV_102_3_pre + CV_102_4_pre + CV_102_5_pre + CV_102_6_pre) (CV_102_0_pim + CV_102_1_pim + CV_102_2_pim + CV_102_3_pim + CV_102_4_pim + CV_102_5_pim + CV_102_6_pim) := by
  simp only [CV_coeff_102, CV_102_0_mul, CV_102_1_mul, CV_102_2_mul, CV_102_3_mul, CV_102_4_mul, CV_102_5_mul, CV_102_6_mul]
  simp [ofLadj_add, add_assoc]

def CV_102_qre : Polynomial ℚ := interpQ 17279915862 [-116153883609076, 1894894302441612, 2256950842252781, 2969903144934866, 4227489045811544, 2868506839572362, 2626547019104570, 1748950563333405, -20712605475766]
def CV_102_qim : Polynomial ℚ := interpQ 17279915862 [-2020419689455422, -2020419689455422, -1513025837311225, -1705686227800534, 24383311690906, 1240245814284406, 1071187274332444, 2379057662872527, 1420842089883622]
theorem CV_coeff_102_poly_re :
    CV_102_0_pre + CV_102_1_pre + CV_102_2_pre + CV_102_3_pre + CV_102_4_pre + CV_102_5_pre + CV_102_6_pre = (0 : Polynomial ℚ) + Phi11 * CV_102_qre := by
  rw [phi11_interpQ]
  simp only [CV_102_0_pre, CV_102_1_pre, CV_102_2_pre, CV_102_3_pre, CV_102_4_pre, CV_102_5_pre, CV_102_6_pre, CV_102_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_102_poly_im :
    CV_102_0_pim + CV_102_1_pim + CV_102_2_pim + CV_102_3_pim + CV_102_4_pim + CV_102_5_pim + CV_102_6_pim = (0 : Polynomial ℚ) + Phi11 * CV_102_qim := by
  rw [phi11_interpQ]
  simp only [CV_102_0_pim, CV_102_1_pim, CV_102_2_pim, CV_102_3_pim, CV_102_4_pim, CV_102_5_pim, CV_102_6_pim, CV_102_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_102_eq :
    CV_coeff_102 = (0 : Ki) := by
  rw [CV_coeff_102_sum, CV_coeff_102_poly_re,
    CV_coeff_102_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
